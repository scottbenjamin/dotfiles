# Repository Guidelines

## Project Structure & Module Organization
This repository is a GNU Stow-managed dotfiles collection. Top-level directories map to app config roots, symlinked into `~/.config` via `stow --target=~/.config`.

Key areas:
- `nvim/`: Primary Neovim config (active at `~/.config/nvim`). Uses native `vim.pack` plugin manager with tiered lazy loading (Tier 1–4). LSP servers are configured as individual files in `nvim/lsp/*.lua`. Plugin lock state is in `nvim/nvim-pack-lock.json`.
- `nvim-custom/`: Alternate Neovim config (via `NVIM_APPNAME=nvim-custom`). Same architecture as `nvim/`.
- `fish/functions/*`, `fish/conf.d/*`, `fish/tests/*`: shell functions and lightweight tests.
- `niri/config.kdl` + `niri/config.d/*.kdl`: compositor config split by concern.
- `waybar/config.jsonc`, `waybar/style.css`, `waybar/modules/*`: bar config and custom modules.
- `aerospace/`: macOS tiling window manager config.
- `tmux/`: tmux config and plugins.
- `ghostty/`, `wezterm/`, `zellij/`: terminal emulator configs.
- `nix/`: Nix/flake configurations.
- `scripts/`: standalone utility scripts.
- `themes/`, `hypr/wallpapers/`: shared theme and wallpaper assets.

## Build, Test, and Development Commands
- `stow -R .`: (re)symlink configs into `~/.config` and related targets.
- `niri validate -c niri/config.kdl`: validate Niri config syntax before commit.
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
- Preserve existing file style and indentation (KDL/CSS/JSON/Lua/Fish as currently written).
- Neovim Lua: 2-space indent, 120 col width (enforced by `nvim/stylua.toml`).
- Keep changes minimal and local to the relevant app directory.
- For Niri, place settings in the matching `config.d` file and keep include order stable.
- Prefer descriptive file names by concern (example: `52-rules-steam.kdl`).

## Testing Guidelines
- Validate only what you touched:
  - Niri changes: `niri validate -c niri/config.kdl`.
  - Neovim Lua changes: `stylua --check nvim/**/*.lua`.
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
- Before disabling or removing built-in Neovim plugins, verify that existing plugins actually replace the functionality rather than guessing.
