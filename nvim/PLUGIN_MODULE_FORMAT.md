# Neovim Plugin Module Format

This Neovim config uses native `vim.pack` plus a local loader in `lua/plugins/pack.lua`.

Plugin modules live in `lua/plugins/*.lua`. The loader auto-discovers each module and supports two styles:

- Legacy style: expose `setup()` and do all work manually.
- Declarative style: define metadata fields (`event`, `keys`, `opts`, `config`) and let loader wire things.

Declarative style is preferred for new modules.

## Recommended Module Shape

```lua
local M = {
  name = "conform.nvim",
  spec = "https://github.com/stevearc/conform.nvim",
  event = "UIEnter",
  keys = {
    { "<leader>cf", function() require("conform").format({ async = true }) end, mode = "", desc = "Format buffer" },
  },
  opts = {
    -- plugin setup opts
  },
}

function M.config(_, opts)
  require("conform").setup(opts)
end

return M
```

## Supported Fields

- `name` (string): plugin package name used by `:packadd`.
- `spec` (string or list): plugin spec(s) passed to `vim.pack.add()`.
- `event` (string or list): autocmd event(s) that trigger plugin setup.
- `once` (boolean, optional): whether event handler runs once (default `true`).
- `defer_ms` (number, optional): delay setup callback by N ms after event.
- `keys` (list, optional): keymap specs, each with:
  - `[1]`: lhs
  - `[2]`: rhs (function/string)
  - `mode` (optional, default `"n"`)
  - any `vim.keymap.set` options like `desc`, `silent`, `expr`, etc.
- `opts` (table or function returning table): config options passed to `config`.
- `config(mod, opts)` (function): setup hook run after `packadd`.
- `setup()` (function): legacy escape hatch. If present, loader runs this and skips declarative flow.

## Loader Behavior

For declarative modules, loader in `lua/plugins/pack.lua` does:

1. Register `keys` immediately.
2. If `event` exists, create autocmd and run setup on event.
3. Otherwise setup immediately.
4. Setup sequence:
   - `packadd(name)`
   - resolve `opts` (call if function)
   - run `config(mod, opts)` if provided

For legacy modules with `setup()`, loader leaves full control to module.

## Migration Notes

When converting old modules:

1. Move plugin setup table into `opts`.
2. Move plugin initialization body into `config`.
3. Replace explicit autocmd boilerplate with `event`/`defer_ms`.
4. Replace `vim.keymap.set(...)` calls with `keys` entries.

Keep module-local helper functions when plugin needs custom logic (example: Mason open command and one-time guard).
