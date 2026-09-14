# Repository Guidelines

## Project Structure & Module Organization
This repository is a GNU Stow-managed dotfiles collection. Top-level directories map to app config roots, symlinked into `~/.config` via `stow --target=~/.config`.

Key areas:
- `nvim/`: Primary Neovim config (active at `~/.config/nvim`). Uses native `vim.pack` plugin manager with tiered lazy loading (Tier 1–4). LSP servers are configured as individual files in `nvim/lsp/*.lua`. Plugin lock state is in `nvim/nvim-pack-lock.json`.
- `nvim-custom/`: Alternate Neovim config (via `NVIM_APPNAME=nvim-custom`). Same architecture as `nvim/`.
- `fish/functions/*`, `fish/conf.d/*`, `fish/tests/*`: shell functions and lightweight tests.
- `mango/config.conf` + `mango/cfg/*.conf`: MangoWM compositor config split by concern (`keybinds`, `rules`, `layout`, etc.).
- `mango/scripts/*`: compositor helper scripts (layout switching, scroller width).
- `noctalia/config.toml`, `noctalia/plugins/*`: Noctalia shell (bar, wallpaper, idle/lock, control center) and custom plugins (e.g. `scott/mango_layouts` layout switcher).
- `herdr/config.toml`, `herdr/plugins.json`: [Herdr](https://herdr.dev/) terminal multiplexer for AI-agent panes, workspaces, and worktrees. Runtime state (`session.json`, logs) is gitignored.
- `herdr-plugins/*`: local Herdr plugin sources (e.g. `gitlab-review`). Install with `herdr plugin link <path>`.
- `opencode/opencode.json`, `opencode/plugins/*`: [OpenCode](https://opencode.ai/) agent config (models, MCP servers, subagents). `plugins/herdr-agent-state.js` is managed by Herdr's OpenCode integration.
- `pi-agent/.pi/agent/`: shared Pi coding-agent settings (`settings.json`, themes, `AGENTS.md`). Stow separately to `$HOME` (see Stow layout).
- `pi-home/.pi/agent/`: machine-local Pi overlays (extensions, policies, prompts). Auth/sessions/cache are gitignored. Stow separately to `$HOME`.
- `voxtype/config.toml`: [VoxType](https://voxtype.io) voice dictation (Whisper/Parakeet). Tray autostart + user systemd unit with GPU override.
- `autostart/*.desktop`: XDG autostart entries (VoxType tray, LookPilot, 1Password, arch-update-tray).
- `environment.d/*.conf`: session environment (Wayland toolkits, theme/cursor, graphics, DMS defaults).
- `systemd/user/*`: user systemd units and drop-ins (e.g. `voxtype.service` GPU env).
- `waybar/config.jsonc`, `waybar/style.css`, `waybar/modules/*`: legacy bar config (Niri sessions).
- `niri/config.kdl` + `niri/config.d/*.kdl`: legacy Niri compositor config (retained, not daily driver).
- `aerospace/`: macOS tiling window manager config.
- `tmux/`: tmux config and plugins.
- `ghostty/`, `wezterm/`, `zellij/`: terminal emulator configs.
- `nix/`: Nix/flake configurations.
- `scripts/`: standalone utility scripts.
- `themes/`, `hypr/wallpapers/`: shared theme and wallpaper assets.

## Build, Test, and Development Commands
- `stow -R .`: (re)symlink configs into `~/.config` and related targets.
- `stow -Rv --target="$HOME" pi-agent`: link shared Pi agent config to `~/.pi/agent`.
- `stow -Rv --target="$HOME" pi-home`: link machine-local Pi extensions/policies to `~/.pi/agent`.
- `mango -p -c mango/config.conf`: validate MangoWM config syntax before commit.
- `fish fish/tests/test_wt.fish`: run the existing Fish function test script.
- `stylua --check nvim/**/*.lua`: check Neovim Lua formatting (config: `nvim/stylua.toml`).
- `stylua nvim/**/*.lua`: auto-format Neovim Lua files.

Use targeted checks for changed areas; avoid broad, slow commands unless needed.

## Neovim Config Architecture
The `nvim/` config uses Neovim 0.12's native `vim.pack` — not lazy.nvim or packer.

- **Plugin management**: `vim.pack.add()` in `init.lua` declares all plugins. `:PackUpdate` fetches and applies updates with revision tracking. `:PackStatus` shows current state.
- **Build hooks**: `PackChanged` autocmd runs build commands (e.g., `cargo build --release` for blink.cmp) after plugin install/update.
- **Tiered loading**: Plugins load in stages to minimize startup time:
  - Tier 1 (immediate): colorscheme, snacks.nvim, lualine, nvim-web-devicons
  - Tier 1.5 (BufReadPre): blink.cmp, LSP config
  - Tier 2 (UIEnter): oil, mason, treesitter, mini.nvim, which-key, lazydev, conform
  - Tier 3 (event-driven): gitsigns, nvim-lint, quicker
  - Tier 4 (on-demand): trouble, nvim-ansible
- **LSP servers**: Individual config files in `nvim/lsp/`. Add a new `nvim/lsp/<server>.lua` to enable a server. `vim.lsp.enable()` auto-discovers them.
- **Daily update check**: On startup (after 5s delay), async git fetch checks for plugin updates and notifies via Snacks.

## Coding Style & Naming Conventions
- Preserve existing file style and indentation (conf/KDL/CSS/JSON/Lua/Fish as currently written).
- Neovim Lua: 2-space indent, 120 col width (enforced by `nvim/stylua.toml`).
- Keep changes minimal and local to the relevant app directory.
- For MangoWM, place settings in the matching `mango/cfg/*.conf` file and keep `config.conf` source order stable.
- Prefer descriptive file names by concern (example: `rules.conf`, `keybinds.conf`).

## Testing Guidelines
- Validate only what you touched:
  - MangoWM changes: `mango -p -c mango/config.conf`.
  - Neovim Lua changes: `stylua --check nvim/**/*.lua`.
  - Fish function changes: run `fish/tests/test_wt.fish` (and add tests near related functions when practical).
  - UI/runtime configs (Noctalia, Ghostty, Herdr, VoxType, Waybar): verify in-session behavior and note what was manually checked.

Do not claim verification unless commands/manual checks were actually run.

## Commit & Pull Request Guidelines
History uses short, pragmatic commit subjects. Follow that style, but make messages clearer:
- Prefer imperative, scoped subjects (example: `mango: split window rules into cfg files`).
- Keep one logical change per commit.

PRs should include:
- What changed and why.
- Affected paths (example: `mango/cfg/keybinds.conf`).
- Validation performed (commands + outcomes).
- Screenshots only for visible UI changes.

## Security & Configuration Tips
- Never commit secrets, tokens, or machine-specific credentials.
- Keep host-specific paths minimal and clearly intentional.
- Review autostart entries to avoid duplicate launches (XDG autostart vs compositor startup).

## Corrections
- Before making or changing behavior in app configs, check the relevant official docs first (for example, [MangoWM docs](https://mangowm.github.io/docs/)) and then implement against documented semantics.
- Before disabling or removing built-in Neovim plugins, verify that existing plugins actually replace the functionality rather than guessing.

## Quick Start
1. Clone repo.
2. Install GNU Stow: `brew install stow` (macOS) or `apt install stow` (Linux).
3. Symlink configs: `stow -R .` from repo root. Check target conflicts: `stow --simulate .`.
4. Link Pi agent configs separately: `stow -Rv --target="$HOME" pi-agent` and, if used, `stow -Rv --target="$HOME" pi-home`.
5. Link Herdr plugins from `herdr-plugins/` (example: `herdr plugin link ~/code/dotfiles/herdr-plugins/gitlab-review`).
6. Validate touched area (see Testing Guidelines).
7. Commit and push.

## Stow layout
Most packages map to `~/.config/<name>/` via root `stow -R .` (`.stowrc` sets `--target=~/.config`).

Exceptions:
- `pi-agent`, `pi-home`: target `$HOME` because config lives at `~/.pi/agent/`. `pi-agent` is excluded in `.stowrc`; run both stow commands manually.
- `tmux`: excluded from default stow; link or copy `tmux/tmux.conf` manually if needed.
- `herdr-plugins/`: not a stow package; plugins are installed with `herdr plugin link`.

## Plugin Lock Management
`nvim-pack-lock.json` tracks exact plugin revisions (pins from `:PackUpdate`).
- **Update pins:** Run `:PackUpdate` in Neovim, commits lock file changes separately.
- **CI/CD:** Treat lock file like package-lock — include in commits, do not auto-update in CI.
- **Manual override:** Edit lock JSON by hand only for conflict resolution; prefer `:PackUpdate`.
- **Version strategy:** Floating (track latest tip) by default. Pin specific revisions only for stability-critical plugins (LSP, blink.cmp).

## Cross-Config Testing
Some changes span multiple tools (e.g., tmux keybinds + Neovim mappings, mango rules + noctalia bar):
- **Tmux ↔ Neovim:** Check keybind collisions in `tmux/tmux.conf` vs `nvim/keymaps.lua`. Test actual escape sequences with `tmux send-keys "..."` + `nvim` interaction.
- **MangoWM ↔ Noctalia:** After mango rule or layout changes, verify noctalia bar widgets (e.g. `scott/mango_layouts`) still respond correctly; check tag/workspace switching.
- **Herdr ↔ OpenCode/Pi:** After agent config changes, verify Herdr pane state reporting and session restore. OpenCode's Herdr plugin is overwritten by Herdr's integration installer — add custom hooks beside it, not inside `herdr-agent-state.js`.
- **Theme propagation:** After theme/color changes, test across mango (`appearance.conf`), noctalia, nvim (colorscheme), terminal emulator (colors).
- **Stow symlink side effects:** Test `stow -R .` doesn't clobber user-created files in `~/.config`; use `--simulate` first.

## nvim-custom Split Criteria
Use alternate config (`nvim-custom/`) only when:
- Running fundamentally different workflows (e.g., distraction-free writing vs full IDE).
- Testing breaking plugin changes without affecting daily editor.
- Splitting core architecture (not just theme/keybind tweaks).

Otherwise, keep single `nvim/` and use `vim.g.vs_enabled = false` flags for conditional features. Rationale: duplicate maintenance is expensive; alias cost is nil.

## Theme & Wallpaper Sync
`themes/` and `hypr/wallpapers/` are shared assets:
- **Colorscheme updates:** Edit `themes/colors.yaml` or similar source-of-truth. Then regenerate nvim colorscheme, mango `appearance.conf`, noctalia theme, terminal themes. Document the flow if multi-step.
- **Wallpaper rotation:** Wallpaper paths in compositor/bar configs should point to `hypr/wallpapers/` symlinked into `~/.config`. Test that the compositor or bar finds images after `stow -R .`.
- **Keep DRY:** Don't duplicate color values across mango, noctalia, nvim — derive from one source if practical.

## Breaking Changes Protocol
If renaming a plugin, config path, or deleting a file:
1. **Deprecation window:** Leave old file for 1–2 commits with a comment pointing to new location.
2. **Migration note:** Mention in commit message (`nvim: migrate <old> → <new>`).
3. **User impact:** If someone already cloned this repo, `stow -R .` may leave orphans. Note in PR or commit comment: "Old file `<path>` left in place; remove manually if needed."
4. **Hard cutoff:** After 1–2 commits, delete old file entirely to prevent confusion.

## Troubleshooting
- **Stow symlink conflicts:** `stow --simulate .` shows what would change. Remove conflicting files in `~/.config` manually, then `stow -R .`.
- **Plugin update fails:** Check `nvim-pack-lock.json` — a pinned revision may no longer exist. Run `:PackStatus` and `:PackUpdate` to sync.
- **MangoWM config errors:** Run `mango -p -c mango/config.conf` and fix reported issues. Check that all `source =` paths in `config.conf` resolve and included `cfg/*.conf` files are valid.
- **Herdr plugin not found:** Run `herdr plugin link` from `herdr-plugins/<name>` and confirm with `herdr plugin action list`. Plugin secrets live in `herdr plugin config-dir <id>/` (not tracked).
- **VoxType not starting:** Check `systemctl --user status voxtype` and `systemd/user/voxtype.service.d/gpu.conf` device override. Tray autostart is in `autostart/voxtype-tray.desktop`.
- **Pi config not loading:** Confirm `stow -Rv --target="$HOME" pi-agent` (and `pi-home` if used). Auth goes in `pi-home/.pi/agent/auth.json` (gitignored; use `auth.template.json` as reference).
- **Niri validate errors (legacy):** Ensure KDL syntax (spacing, semicolons) matches grammar. Check included files in `config.d/` are valid.
- **Fish function not found:** Ensure `fish/functions/*.fish` files are in repo root `fish/functions/` directory, not nested. Stow creates `~/.config/fish/functions/` symlinks automatically.
- **Lua formatting issues:** Run `stylua --check nvim/**/*.lua` to catch 120-col violations and inconsistent spacing before commit.
