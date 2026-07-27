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

## Quick Start
1. Clone repo.
2. Install GNU Stow: `brew install stow` (macOS) or `apt install stow` (Linux).
3. Symlink configs: `stow -R .` from repo root. Check target conflicts: `stow --simulate .`.
4. Validate touched area (see Testing Guidelines).
5. Commit and push.

## Plugin Lock Management
`nvim-pack-lock.json` tracks exact plugin revisions (pins from `:PackUpdate`).
- **Update pins:** Run `:PackUpdate` in Neovim, commits lock file changes separately.
- **CI/CD:** Treat lock file like package-lock — include in commits, do not auto-update in CI.
- **Manual override:** Edit lock JSON by hand only for conflict resolution; prefer `:PackUpdate`.
- **Version strategy:** Floating (track latest tip) by default. Pin specific revisions only for stability-critical plugins (LSP, blink.cmp).

## Cross-Config Testing
Some changes span multiple tools (e.g., tmux keybinds + Neovim mappings, niri rules + waybar style):
- **Tmux ↔ Neovim:** Check keybind collisions in `tmux/tmux.conf` vs `nvim/keymaps.lua`. Test actual escape sequences with `tmux send-keys "..."` + `nvim` interaction.
- **Niri ↔ Waybar:** After niri rule changes, verify waybar windows still appear and respond correctly; check workspace switching.
- **Theme propagation:** After theme/color changes, test across niri (background), waybar (colors), nvim (colorscheme), terminal emulator (colors).
- **Stow symlink side effects:** Test `stow -R .` doesn't clobber user-created files in `~/.config`; use `--simulate` first.

## nvim-custom Split Criteria
Use alternate config (`nvim-custom/`) only when:
- Running fundamentally different workflows (e.g., distraction-free writing vs full IDE).
- Testing breaking plugin changes without affecting daily editor.
- Splitting core architecture (not just theme/keybind tweaks).

Otherwise, keep single `nvim/` and use `vim.g.vs_enabled = false` flags for conditional features. Rationale: duplicate maintenance is expensive; alias cost is nil.

## Theme & Wallpaper Sync
`themes/` and `hypr/wallpapers/` are shared assets:
- **Colorscheme updates:** Edit `themes/colors.yaml` or similar source-of-truth. Then regenerate nvim colorscheme, waybar theme, niri colors, terminal themes. Document the flow if multi-step.
- **Wallpaper rotation:** Niri/Hyprland background paths should point to `hypr/wallpapers/` symlinked into `~/.config`. Test that compositor finds images after `stow -R .`.
- **Keep DRY:** Don't duplicate color values across niri, waybar, nvim — derive from one source if practical.

## Breaking Changes Protocol
If renaming a plugin, config path, or deleting a file:
1. **Deprecation window:** Leave old file for 1–2 commits with a comment pointing to new location.
2. **Migration note:** Mention in commit message (`nvim: migrate <old> → <new>`).
3. **User impact:** If someone already cloned this repo, `stow -R .` may leave orphans. Note in PR or commit comment: "Old file `<path>` left in place; remove manually if needed."
4. **Hard cutoff:** After 1–2 commits, delete old file entirely to prevent confusion.

## Troubleshooting
- **Stow symlink conflicts:** `stow --simulate .` shows what would change. Remove conflicting files in `~/.config` manually, then `stow -R .`.
- **Plugin update fails:** Check `nvim-pack-lock.json` — a pinned revision may no longer exist. Run `:PackStatus` and `:PackUpdate` to sync.
- **Niri validate errors:** Ensure KDL syntax (spacing, semicolons) matches grammar. Check included files in `config.d/` are valid.
- **Fish function not found:** Ensure `fish/functions/*.fish` files are in repo root `fish/functions/` directory, not nested. Stow creates `~/.config/fish/functions/` symlinks automatically.
- **Lua formatting issues:** Run `stylua --check nvim/**/*.lua` to catch 120-col violations and inconsistent spacing before commit.
