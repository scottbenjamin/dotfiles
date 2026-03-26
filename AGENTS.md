# Repository Guidelines

## Project Structure & Module Organization
This repository is a GNU Stow-managed dotfiles collection. Top-level directories map to app config roots (for example `niri/`, `waybar/`, `fish/`, `ghostty/`, `hypr/`, `sway/`, `wezterm/`, `nvim/`, `nvim-custom/`, `tmux/`).

Key areas:
- `niri/config.kdl` + `niri/config.d/*.kdl`: compositor config split by concern.
- `waybar/config.jsonc`, `waybar/style.css`, `waybar/modules/*`: bar config and custom modules.
- `fish/functions/*`, `fish/conf.d/*`, `fish/tests/*`: shell functions and lightweight tests.
- `nvim*/`: Neovim configs and plugin specs.
- `themes/`, `hypr/wallpapers/`: shared theme and wallpaper assets.

## Build, Test, and Development Commands
- `stow -R .`: (re)symlink configs into `~/.config` and related targets.
- `niri validate -c niri/config.kdl`: validate Niri config syntax before commit.
- `fish fish/tests/test_wt.fish`: run the existing Fish function test script.
- `stylua nvim/**/*.lua nvim-custom/**/*.lua`: format Neovim Lua files (uses `stylua.toml`).

Use targeted checks for changed areas; avoid broad, slow commands unless needed.

## Coding Style & Naming Conventions
- Preserve existing file style and indentation (KDL/CSS/JSON/Lua/Fish as currently written).
- Keep changes minimal and local to the relevant app directory.
- For Niri, place settings in the matching `config.d` file and keep include order stable.
- Prefer descriptive file names by concern (example: `52-rules-steam.kdl`).

## Testing Guidelines
- Validate only what you touched:
- Niri changes: `niri validate -c niri/config.kdl`.
- Fish function changes: run `fish/tests/test_wt.fish` (and add tests near related functions when practical).
- UI/runtime configs (Waybar, Ghostty, Hyprland, Sway): verify in-session behavior and note what was manually checked.

Do not claim verification unless commands/manual checks were actually run.

## Commit & Pull Request Guidelines
History uses short, pragmatic commit subjects. Follow that style, but make messages clearer:
- Prefer imperative, scoped subjects (example: `niri: split window rules into config.d files`).
- Keep one logical change per commit.

PRs should include:
- What changed and why.
- Affected paths (example: `niri/config.d/60-binds.kdl`).
- Validation performed (commands + outcomes).
- Screenshots only for visible UI changes.

## Security & Configuration Tips
- Never commit secrets, tokens, or machine-specific credentials.
- Keep host-specific paths minimal and clearly intentional.
- Review autostart entries to avoid duplicate launches (XDG autostart vs compositor startup).

## Corrections
- Before making or changing behavior in app configs, check the relevant official docs first (for example, the Hyprland wiki) and then implement against documented semantics.
