# Scott's dotfiles

<!--toc:start-->
- [Scott's dotfiles](#scotts-dotfiles)
  - [Getting started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Stow](#stow)
  - [Pi agent config](#pi-agent-config)
  - [Herdr plugins](#herdr-plugins)
  - [Notes](#notes)
<!--toc:end-->

GNU Stow-managed configs for a MangoWM + Noctalia desktop, Neovim, Fish, Ghostty, Herdr, and AI-agent tooling.

## Getting started

Clone this repo, install prerequisites, then symlink configs with Stow (see below). Most packages land in `~/.config/`; Pi and Herdr plugins need extra steps.

## Prerequisites

- GNU Stow
- **Desktop:** MangoWM, [Noctalia](https://noctalia.dev/), `mmsg` (MangoWM CLI), `jq`
- **Shell/editor/terminal:** Fish, Neovim, Ghostty (primary terminal)
- **AI agents:** [Herdr](https://herdr.dev/), [OpenCode](https://opencode.ai/), Pi coding agent
- **Voice:** [VoxType](https://voxtype.io/) (`voxtype`, `voxtype-tray`)
- Nerd Font(s) for terminal, editor, and bar themes
- Noctalia bar helpers as needed: `playerctl`, `curl`

Legacy configs for Niri and Waybar are still in the repo but are not the daily driver.

## Stow

From the repo root:

```shell
stow -R .
```

Then link Pi agent configs (not covered by root stow):

```shell
stow -Rv --target="$HOME" pi-agent
stow -Rv --target="$HOME" pi-home   # optional machine-local extensions
```

Validate MangoWM config after changes:

```shell
mango -p -c mango/config.conf
```

Check for conflicts before applying:

```shell
stow --simulate .
```

## Pi agent config

Tracked Pi config lives in `pi-agent/.pi/agent/` (shared settings) and `pi-home/.pi/agent/` (machine-local extensions, policies, prompts).

Because `.stowrc` targets `~/.config`, stow both packages separately to `$HOME`:

```shell
stow -Rv --target="$HOME" pi-agent
stow -Rv --target="$HOME" pi-home
```

Only non-secret files are tracked. Auth, sessions, cache, and logs are gitignored — copy `pi-home/.pi/agent/auth.template.json` to `auth.json` locally.

## Herdr plugins

Local plugin sources live in `herdr-plugins/`. Install with:

```shell
herdr plugin link ~/code/dotfiles/herdr-plugins/gitlab-review
```

Plugin secrets go in `herdr plugin config-dir <id>/` (not tracked). See `herdr-plugins/gitlab-review/README.md`.

## Notes

- `tmux` is intentionally excluded from `.stowrc`; link or copy `tmux/tmux.conf` manually if you use tmux.
- `pi-agent` is excluded from root stow in `.stowrc`; run its stow command manually.
- VoxType starts via user systemd (`systemd/user/`) and tray autostart (`autostart/voxtype-tray.desktop`).
- See [AGENTS.md](AGENTS.md) for full repo guidelines, cross-config testing, and troubleshooting.
