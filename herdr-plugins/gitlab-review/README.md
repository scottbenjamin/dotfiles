# GitLab MR Review — herdr plugin

On demand, list the GitLab merge requests **awaiting your review** and open one
in a herdr worktree with a `claude` agent to review it.

## What it does

- **Picker** — fzf overlay of every MR awaiting your review. Each row shows a
  readiness icon (✅ ready / 📝 draft), an approvals icon (🟩 enough / 🟨 some /
  ⬜ none), `project!iid`, title, author, and age. The preview pane shows full
  detail: state, branches, CI status, approvals (who), reviewers (✓ = approved),
  labels, change count, and the description. `enter` → review in a worktree,
  `ctrl-d` → just the diff. The list paints immediately from one API call
  (approval icons show `⋯`); approval state resolves a moment later and the list
  reloads (dropping any you've already approved). Cached briefly for instant reopen.
- **Review** — checks out the MR head into a herdr worktree
  (`herdr worktree create`) and opens two panes: pane 1 the MR's changed files
  (delta side-by-side by default — set `HERDR_GL_DIFF_VIEWER=delta|less|lazygit`;
  quitting the viewer closes the pane), pane 2 `claude` reviewing the code.
- **Link handler** — `ctrl+click` any `…/-/merge_requests/N` URL in a pane to
  review that MR directly.

Shows every **open** MR where you're on the reviewers list and haven't already
approved — drafts included, flagged with 📝 so you can tell. (Closed/merged,
not-a-reviewer, and already-approved MRs are excluded.)

## Layout

Two files, per the [herdr plugin model](https://herdr.dev/docs/plugins/)
(manifest + one command):

```
herdr-plugin.toml     # manifest: actions, picker pane, MR-URL link handler
gitlab-review.sh      # one script; the manifest calls it with a subcommand
                      #   list | picker | review | diff
```

## Requirements

`herdr` ≥ 0.7.0, `glab` (authenticated: `glab auth login`), `jq`, `fzf`.
`claude` on PATH for the review agent. Diff pane uses `delta` (default);
`less` and `lazygit` are alternatives.

## Install (local dev)

```bash
herdr plugin link ~/code/dotfiles/herdr-plugins/gitlab-review
herdr plugin action list --plugin absci.gitlab-review

# optional config
cp ~/code/dotfiles/herdr-plugins/gitlab-review/.env.example \
   "$(herdr plugin config-dir absci.gitlab-review)/.env"
```

## Usage

```bash
herdr plugin action invoke absci.gitlab-review.list   # open the picker
```

### Keybinding

Bound in `~/.config/herdr/config.toml`, not the manifest:

```toml
[[keys.command]]
key = "prefix+m"
type = "plugin_action"
command = "absci.gitlab-review.list"
description = "GitLab MRs awaiting review"
```

## Config

See `.env.example`. Copy it into `herdr plugin config-dir absci.gitlab-review`.

### Review agent

`HERDR_GL_REVIEW_AGENT` picks the agent that reviews the MR:

- `claude` (default) — launches `claude --model sonnet`
- `pi` — launches `pi`
- `cursor` — launches `cursor-agent --model composer-2.5`
- any other binary on PATH that takes a trailing prompt + optional `--model`
  (e.g. `codex`, `gemini`)

`HERDR_GL_REVIEW_MODEL` overrides the model (unset = per-agent default: claude→sonnet,
cursor→composer-2.5, pi→its own; set to `""` to force the agent's own default).

## Notes

- Review assumes SSH clone access; repos not found under `HERDR_GL_REPOS_DIR`
  are shallow-cloned into the cache dir.
