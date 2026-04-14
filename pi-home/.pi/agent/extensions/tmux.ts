import { execFile } from "node:child_process";
import { chmod, mkdtemp, rm, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { promisify } from "node:util";
import {
  DEFAULT_MAX_BYTES,
  DEFAULT_MAX_LINES,
  createBashTool,
  defineTool,
  formatSize,
  type BashOperations,
  type ExtensionAPI,
  truncateTail,
} from "@mariozechner/pi-coding-agent";
import { Type } from "@sinclair/typebox";

const execFileAsync = promisify(execFile);
const TMUX_CAPTURE_LINES_DEFAULT = 200;
const TMUX_CAPTURE_LINES_MAX = 1000;
const TMUX_POLL_INTERVAL_MS = 200;
const TMUX_BACKEND_WINDOW_PREFIX = "pi-exec";
const TMUX_LIST_FORMAT = [
  "#{session_name}:#{window_index}.#{pane_index}",
  "#{pane_id}",
  "#{session_name}",
  "#{window_index}",
  "#{pane_index}",
  "#{window_name}",
  "#{pane_title}",
  "#{pane_current_command}",
  "#{pane_current_path}",
  "#{pane_active}",
].join("\t");

interface TmuxPaneTarget {
  target: string;
  paneId: string;
  sessionName: string;
  windowIndex: string;
  paneIndex: string;
  windowName: string;
  paneTitle: string;
  currentCommand: string;
  currentPath: string;
  active: boolean;
}

interface ManagedSession {
  sessionName: string;
  cleanupOnShutdown: boolean;
}

interface BackendConfig {
  enabled: boolean;
  target?: string;
  sessionName?: string;
  createIfMissing: boolean;
  cleanupOnShutdown: boolean;
}

interface BackendWindow {
  windowId: string;
  paneId: string;
}

async function runTmux(args: string[], signal?: AbortSignal): Promise<string> {
  try {
    const { stdout } = await execFileAsync("tmux", args, {
      encoding: "utf8",
      maxBuffer: 10 * 1024 * 1024,
      signal,
    });
    return stdout;
  } catch (error) {
    const message =
      error instanceof Error && "stderr" in error && typeof error.stderr === "string" && error.stderr.trim()
        ? error.stderr.trim()
        : error instanceof Error
          ? error.message
          : String(error);
    throw new Error(`tmux ${args[0]} failed: ${message}`);
  }
}

function parsePaneLine(line: string): TmuxPaneTarget | undefined {
  if (!line.trim()) return undefined;
  const parts = line.split("\t");
  if (parts.length < 10) return undefined;
  return {
    target: parts[0],
    paneId: parts[1],
    sessionName: parts[2],
    windowIndex: parts[3],
    paneIndex: parts[4],
    windowName: parts[5],
    paneTitle: parts[6],
    currentCommand: parts[7],
    currentPath: parts[8],
    active: parts[9] === "1",
  };
}

async function listPaneTargets(signal?: AbortSignal): Promise<TmuxPaneTarget[]> {
  try {
    const output = await runTmux(["list-panes", "-a", "-F", TMUX_LIST_FORMAT], signal);
    return output
      .split("\n")
      .map(parsePaneLine)
      .filter((pane): pane is TmuxPaneTarget => Boolean(pane));
  } catch (error) {
    if (error instanceof Error && error.message.includes("no server running")) {
      return [];
    }
    throw error;
  }
}

async function sessionExists(sessionName: string, signal?: AbortSignal): Promise<boolean> {
  try {
    await runTmux(["has-session", "-t", sessionName], signal);
    return true;
  } catch (error) {
    if (error instanceof Error && error.message.includes("can't find session")) {
      return false;
    }
    if (error instanceof Error && error.message.includes("no server running")) {
      return false;
    }
    throw error;
  }
}

async function killSession(sessionName: string, signal?: AbortSignal): Promise<void> {
  try {
    await runTmux(["kill-session", "-t", sessionName], signal);
  } catch (error) {
    if (error instanceof Error && (error.message.includes("can't find session") || error.message.includes("no server running"))) {
      return;
    }
    throw error;
  }
}

async function killWindow(windowId: string, signal?: AbortSignal): Promise<void> {
  try {
    await runTmux(["kill-window", "-t", windowId], signal);
  } catch (error) {
    if (error instanceof Error && (error.message.includes("can't find window") || error.message.includes("no server running"))) {
      return;
    }
    throw error;
  }
}

async function resolvePaneTarget(target: string, signal?: AbortSignal): Promise<TmuxPaneTarget> {
  const panes = await listPaneTargets(signal);
  const normalized = target.trim();
  const pane = panes.find((entry) => entry.target === normalized || entry.paneId === normalized);
  if (!pane) {
    throw new Error(`Unknown tmux target: ${target}`);
  }
  return pane;
}

function formatPaneTarget(pane: TmuxPaneTarget): string {
  const active = pane.active ? " active" : "";
  return `${pane.target} (${pane.paneId})${active}
command: ${pane.currentCommand || "-"}
path: ${pane.currentPath || "-"}
window: ${pane.windowName || "-"}
title: ${pane.paneTitle || "-"}`;
}

function clampCaptureLines(value?: number): number {
  if (!value || Number.isNaN(value)) return TMUX_CAPTURE_LINES_DEFAULT;
  return Math.max(1, Math.min(TMUX_CAPTURE_LINES_MAX, value));
}

function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function shellQuote(value: string): string {
  return `'${value.replace(/'/g, `'\\''`)}'`;
}

function sanitizeWindowName(value: string): string {
  const sanitized = value.replace(/[^a-zA-Z0-9_-]/g, "-");
  return sanitized || TMUX_BACKEND_WINDOW_PREFIX;
}

function buildEnvScript(env: NodeJS.ProcessEnv | undefined): string {
  if (!env) return "";

  const lines: string[] = [];
  for (const [key, value] of Object.entries(env)) {
    if (!/^[A-Za-z_][A-Za-z0-9_]*$/.test(key)) continue;
    if (value === undefined) {
      lines.push(`unset ${key}`);
    } else {
      lines.push(`export ${key}=${shellQuote(value)}`);
    }
  }
  return lines.join("\n");
}

async function resolveExecutionSession(
  config: BackendConfig,
  managedSessionRef: { current?: ManagedSession },
  signal?: AbortSignal,
): Promise<string> {
  if (config.target) {
    if (await sessionExists(config.target, signal)) {
      return config.target;
    }

    const pane = await resolvePaneTarget(config.target, signal);
    return pane.sessionName;
  }

  if (!config.sessionName) {
    throw new Error("Tmux backend is enabled but no tmux target or session was configured.");
  }

  if (await sessionExists(config.sessionName, signal)) {
    return config.sessionName;
  }

  if (!config.createIfMissing) {
    throw new Error(
      `Tmux session ${config.sessionName} does not exist. Re-run with --tmux-create-if-missing to create it lazily on first bash use.`,
    );
  }

  await runTmux(["new-session", "-d", "-s", config.sessionName], signal);
  managedSessionRef.current = {
    sessionName: config.sessionName,
    cleanupOnShutdown: config.cleanupOnShutdown,
  };
  return config.sessionName;
}

async function createBackendWindow(
  sessionName: string,
  cwd: string,
  command: string,
  env: NodeJS.ProcessEnv | undefined,
  signal: AbortSignal | undefined,
): Promise<BackendWindow & { tempDir: string; marker: string }> {
  const tempDir = await mkdtemp(join(tmpdir(), "pi-tmux-bash-"));
  const scriptPath = join(tempDir, "run.sh");
  const marker = `__PI_TMUX_EXIT__${Date.now()}_${Math.random().toString(36).slice(2)}__=`;
  const shell = process.env.SHELL || "/bin/bash";
  const envScript = buildEnvScript(env);
  const script = `#!/usr/bin/env bash
cd ${shellQuote(cwd)} || exit 1
${envScript}
${command}
status=$?
printf '\\n${marker}%s\\n' "$status"
while true; do sleep 3600; done
`;

  await writeFile(scriptPath, script, "utf8");
  await chmod(scriptPath, 0o700);

  const commandString = `${shellQuote(shell)} ${shellQuote(scriptPath)}`;
  const windowName = sanitizeWindowName(`${TMUX_BACKEND_WINDOW_PREFIX}-${Date.now().toString(36)}`);
  const output = await runTmux(
    ["new-window", "-d", "-P", "-F", "#{pane_id}\t#{window_id}", "-t", sessionName, "-n", windowName, "-c", cwd, commandString],
    signal,
  );
  const [paneId, windowId] = output.trim().split("\t");
  if (!paneId || !windowId) {
    throw new Error(`Unexpected tmux new-window output: ${output}`);
  }

  return { paneId, windowId, tempDir, marker };
}

async function cleanupBackendWindow(windowId: string, tempDir: string): Promise<void> {
  await Promise.allSettled([killWindow(windowId), rm(tempDir, { recursive: true, force: true })]);
}

function createTmuxBashOps(
  getBackendConfig: () => BackendConfig,
  managedSessionRef: { current?: ManagedSession },
  activeWindowIds: Set<string>,
): BashOperations {
  return {
    exec: async (command, cwd, { onData, signal, timeout, env }) => {
      const config = getBackendConfig();
      if (!config.enabled) {
        throw new Error("Tmux backend is not enabled.");
      }

      const sessionName = await resolveExecutionSession(config, managedSessionRef, signal);
      const backendWindow = await createBackendWindow(sessionName, cwd, command, env, signal);
      activeWindowIds.add(backendWindow.windowId);

      let timedOut = false;
      let timer: NodeJS.Timeout | undefined;
      const onAbort = async () => {
        await killWindow(backendWindow.windowId);
      };

      if (timeout !== undefined && timeout > 0) {
        timer = setTimeout(() => {
          timedOut = true;
          void killWindow(backendWindow.windowId);
        }, timeout * 1000);
      }

      if (signal) {
        if (signal.aborted) await onAbort();
        else signal.addEventListener("abort", () => void onAbort(), { once: true });
      }

      let emittedLength = 0;
      let exitCode: number | null = null;

      try {
        while (exitCode === null) {
          const captured = await runTmux(["capture-pane", "-p", "-J", "-t", backendWindow.paneId], signal);
          const markerIndex = captured.indexOf(backendWindow.marker);
          const visibleOutput = markerIndex >= 0 ? captured.slice(0, markerIndex) : captured;

          if (visibleOutput.length > emittedLength) {
            const delta = visibleOutput.slice(emittedLength);
            emittedLength = visibleOutput.length;
            onData(Buffer.from(delta));
          }

          if (markerIndex >= 0) {
            const suffix = captured.slice(markerIndex + backendWindow.marker.length);
            const match = suffix.match(/^(\d+)/);
            if (!match) {
              throw new Error("Failed to parse tmux backend exit code.");
            }
            exitCode = Number.parseInt(match[1], 10);
            break;
          }

          await sleep(TMUX_POLL_INTERVAL_MS);
        }

        if (signal?.aborted) {
          throw new Error("aborted");
        }
        if (timedOut) {
          throw new Error(`timeout:${timeout}`);
        }

        return { exitCode };
      } finally {
        if (timer) clearTimeout(timer);
        activeWindowIds.delete(backendWindow.windowId);
        await cleanupBackendWindow(backendWindow.windowId, backendWindow.tempDir);
      }
    },
  };
}

const tmuxListTargetsTool = defineTool({
  name: "tmux_list_targets",
  label: "Tmux List Targets",
  description: "List available existing tmux panes that can receive commands. This tool never creates sessions.",
  promptSnippet: "List existing tmux targets before choosing a pane for command execution.",
  promptGuidelines: [
    "Use this before tmux_run_command when the target is not already known.",
    "Prefer explicit session:window.pane targets in later tool calls.",
    "Do not assume this creates tmux sessions; it only inspects what already exists.",
  ],
  parameters: Type.Object({}),
  async execute(_toolCallId, _params, signal) {
    const panes = await listPaneTargets(signal);
    if (panes.length === 0) {
      return {
        content: [{ type: "text", text: "No tmux panes found. Make sure a tmux server is running." }],
        details: { count: 0, panes: [] },
      };
    }

    const lines = panes.map((pane) => formatPaneTarget(pane));
    return {
      content: [{ type: "text", text: lines.join("\n\n") }],
      details: { count: panes.length, panes },
    };
  },
});

const tmuxRunCommandTool = defineTool({
  name: "tmux_run_command",
  label: "Tmux Run Command",
  description: "Send a shell command to a specific existing tmux pane target. This tool never creates sessions.",
  promptSnippet: "Run a command inside an existing tmux pane without creating a new tmux session.",
  promptGuidelines: [
    "Always use an explicit tmux target such as session:window.pane or a pane id.",
    "Use tmux_capture_pane after running a command if you need to inspect its output.",
    "If no suitable session exists, use tmux_create_session explicitly instead of assuming this tool will create one.",
  ],
  parameters: Type.Object({
    target: Type.String({ description: "Pane target like session:window.pane or a pane id such as %3" }),
    command: Type.String({ description: "Shell command to send to the pane" }),
    enter: Type.Optional(Type.Boolean({ description: "Press Enter after sending the command. Defaults to true." })),
  }),
  async execute(_toolCallId, params, signal) {
    const pane = await resolvePaneTarget(params.target, signal);
    const enter = params.enter ?? true;

    await runTmux(["send-keys", "-t", pane.target, "-l", params.command], signal);
    if (enter) {
      await runTmux(["send-keys", "-t", pane.target, "Enter"], signal);
    }

    return {
      content: [
        {
          type: "text",
          text: `Sent command to ${pane.target} (${pane.paneId}).${enter ? " Pressed Enter." : ""}\nCommand: ${params.command}`,
        },
      ],
      details: {
        target: pane.target,
        paneId: pane.paneId,
        command: params.command,
        enter,
        currentPath: pane.currentPath,
        currentCommand: pane.currentCommand,
      },
    };
  },
});

const tmuxCapturePaneTool = defineTool({
  name: "tmux_capture_pane",
  label: "Tmux Capture Pane",
  description: `Capture recent output from an existing tmux pane. Output is truncated to ${DEFAULT_MAX_LINES} lines or ${formatSize(DEFAULT_MAX_BYTES)}.`,
  promptSnippet: "Read recent pane output after running a command in tmux.",
  promptGuidelines: [
    "Use this after tmux_run_command to inspect output without reading the whole scrollback.",
    "Request only as many lines as needed; prefer smaller captures first.",
  ],
  parameters: Type.Object({
    target: Type.String({ description: "Pane target like session:window.pane or a pane id such as %3" }),
    lines: Type.Optional(
      Type.Integer({
        description: `How many lines of recent scrollback to request from tmux (1-${TMUX_CAPTURE_LINES_MAX}). Defaults to ${TMUX_CAPTURE_LINES_DEFAULT}.`,
        minimum: 1,
        maximum: TMUX_CAPTURE_LINES_MAX,
      }),
    ),
  }),
  async execute(_toolCallId, params, signal) {
    const pane = await resolvePaneTarget(params.target, signal);
    const requestedLines = clampCaptureLines(params.lines);
    const output = await runTmux(
      ["capture-pane", "-p", "-J", "-t", pane.target, "-S", `-${requestedLines}`],
      signal,
    );

    if (!output.trim()) {
      return {
        content: [{ type: "text", text: `Pane ${pane.target} has no captured output.` }],
        details: { target: pane.target, paneId: pane.paneId, requestedLines, capturedLines: 0 },
      };
    }

    const truncation = truncateTail(output, {
      maxLines: DEFAULT_MAX_LINES,
      maxBytes: DEFAULT_MAX_BYTES,
    });

    let text = truncation.content;
    if (truncation.truncated) {
      const omittedLines = truncation.totalLines - truncation.outputLines;
      const omittedBytes = truncation.totalBytes - truncation.outputBytes;
      text += `\n\n[Pane output truncated: showing last ${truncation.outputLines} of ${truncation.totalLines} lines`;
      text += ` (${formatSize(truncation.outputBytes)} of ${formatSize(truncation.totalBytes)}).`;
      text += ` ${omittedLines} lines (${formatSize(omittedBytes)}) omitted.]`;
    }

    return {
      content: [{ type: "text", text }],
      details: {
        target: pane.target,
        paneId: pane.paneId,
        requestedLines,
        capturedLines: output.split("\n").filter(Boolean).length,
        truncation,
      },
    };
  },
});

export default function (pi: ExtensionAPI) {
  pi.registerFlag("tmux-target", {
    description: "Enable tmux backend mode using an existing tmux target (session name, session:window.pane, or pane id).",
    type: "string",
  });
  pi.registerFlag("tmux-session", {
    description: "Enable tmux backend mode using a tmux session name. Can be lazily created with --tmux-create-if-missing.",
    type: "string",
  });
  pi.registerFlag("tmux-create-if-missing", {
    description: "When backend mode uses --tmux-session, create the session lazily on first bash execution if it does not already exist.",
    type: "boolean",
    default: false,
  });
  pi.registerFlag("tmux-cleanup", {
    description: "Clean up tmux sessions created lazily by the backend on pi shutdown.",
    type: "boolean",
    default: true,
  });

  const localCwd = process.cwd();
  const localBash = createBashTool(localCwd);
  const backendConfig: BackendConfig = {
    enabled: false,
    createIfMissing: false,
    cleanupOnShutdown: true,
  };
  const managedSessionRef: { current?: ManagedSession } = {};
  const activeWindowIds = new Set<string>();
  const tmuxBashOps = createTmuxBashOps(() => backendConfig, managedSessionRef, activeWindowIds);

  pi.registerTool(tmuxListTargetsTool);
  pi.registerTool(tmuxRunCommandTool);
  pi.registerTool(tmuxCapturePaneTool);
  pi.registerTool({
    ...localBash,
    label: "bash (tmux-capable)",
    async execute(id, params, signal, onUpdate, _ctx) {
      if (!backendConfig.enabled) {
        return localBash.execute(id, params, signal, onUpdate);
      }

      const tmuxBash = createBashTool(localCwd, { operations: tmuxBashOps });
      return tmuxBash.execute(id, params, signal, onUpdate);
    },
  });

  pi.registerCommand("tmux-targets", {
    description: "List available tmux pane targets",
    handler: async (_args, ctx) => {
      const panes = await listPaneTargets();
      if (panes.length === 0) {
        ctx.ui.notify("No tmux panes found.", "warning");
        return;
      }

      await ctx.ui.editor("tmux targets", panes.map((pane) => formatPaneTarget(pane)).join("\n\n"));
    },
  });
  pi.registerCommand("tmux-backend-status", {
    description: "Show current tmux backend mode and lazy session settings",
    handler: async (_args, ctx) => {
      if (!backendConfig.enabled) {
        ctx.ui.notify("Tmux backend mode is disabled. Utility tools are still available.", "info");
        return;
      }

      const targetText = backendConfig.target
        ? `existing target: ${backendConfig.target}`
        : `session: ${backendConfig.sessionName}`;
      const createText = backendConfig.createIfMissing ? "lazy-create enabled" : "lazy-create disabled";
      const cleanupText = backendConfig.cleanupOnShutdown ? "cleanup enabled" : "cleanup disabled";
      const managedText = managedSessionRef.current ? `managed session: ${managedSessionRef.current.sessionName}` : "no session created yet";
      ctx.ui.notify(`Tmux backend active (${targetText}; ${createText}; ${cleanupText}; ${managedText})`, "info");
    },
  });

  pi.on("session_start", async (_event, ctx) => {
    const target = pi.getFlag("tmux-target");
    const sessionName = pi.getFlag("tmux-session");
    const createIfMissing = Boolean(pi.getFlag("tmux-create-if-missing"));
    const cleanupOnShutdown = pi.getFlag("tmux-cleanup") !== false;

    backendConfig.target = typeof target === "string" ? target : undefined;
    backendConfig.sessionName = typeof sessionName === "string" ? sessionName : undefined;
    backendConfig.createIfMissing = createIfMissing;
    backendConfig.cleanupOnShutdown = cleanupOnShutdown;
    backendConfig.enabled = Boolean(backendConfig.target || backendConfig.sessionName);

    if (!backendConfig.enabled) {
      ctx.ui.setStatus("tmux-backend", undefined);
      return;
    }

    const modeText = backendConfig.target
      ? `tmux backend -> ${backendConfig.target}`
      : `tmux backend -> session ${backendConfig.sessionName}${backendConfig.createIfMissing ? " (lazy create)" : ""}`;
    ctx.ui.setStatus("tmux-backend", modeText);
    ctx.ui.notify(`${modeText}. No tmux session will be created until bash is actually used.`, "info");
  });

  pi.on("user_bash", () => {
    if (!backendConfig.enabled) return;
    return { operations: tmuxBashOps };
  });

  pi.on("session_shutdown", async () => {
    const cleanupPromises = Array.from(activeWindowIds).map((windowId) => killWindow(windowId));
    if (cleanupPromises.length > 0) {
      await Promise.allSettled(cleanupPromises);
      activeWindowIds.clear();
    }

    if (managedSessionRef.current?.cleanupOnShutdown) {
      await killSession(managedSessionRef.current.sessionName);
      managedSessionRef.current = undefined;
    }
  });
}
