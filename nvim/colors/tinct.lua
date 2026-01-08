-- Tinct Color Scheme for Neovim
-- Generated automatically by Tinct
-- https://github.com/jmylchreest/tinct

vim.cmd('highlight clear')
if vim.fn.exists('syntax_on') then
  vim.cmd('syntax reset')
end

vim.o.termguicolors = true
vim.g.colors_name = 'tinct'

-- Color Palette
local colors = {
  -- Base colors
  bg = '#060802',
  fg = '#b8b6ae',
  bg_muted = '#2f381e',
  fg_muted = '#908f88',
  bg_subtle = '#2f381e',
  fg_subtle = '#908f88',

  -- Accent colors
  accent1 = '#42a72e',
  accent2 = '#8b65d6',
  accent3 = '#2a80ab',

  -- Semantic colors
  danger = '#e54c4c',
  warning = '#e5bf4c',
  success = '#4fcc36',
  info = '#359bcd',

  -- ANSI colors for terminal
  black = '#000000',
  red = '#e54c4c',
  green = '#4fcc36',
  yellow = '#e5bf4c',
  blue = '#2a80ab',
  magenta = '#d349a5',
  cyan = '#359bcd',
  white = '#eaf4d6',
  bright_black = '#56656d',
  bright_red = '#e54c4c',
  bright_green = '#359bcd',
  bright_yellow = '#e5bf4c',
  bright_blue = '#359bcd',
  bright_magenta = '#8b65d6',
  bright_cyan = '#359bcd',
  bright_white = '#eaf4d6',
}

-- Helper function to set highlight groups
local function hi(group, opts)
  local cmd = 'highlight ' .. group
  if opts.fg then cmd = cmd .. ' guifg=' .. opts.fg end
  if opts.bg then cmd = cmd .. ' guibg=' .. opts.bg end
  if opts.sp then cmd = cmd .. ' guisp=' .. opts.sp end
  if opts.style then cmd = cmd .. ' gui=' .. opts.style end
  if opts.link then cmd = 'highlight! link ' .. group .. ' ' .. opts.link end
  vim.cmd(cmd)
end

-- Editor UI
hi('Normal', { fg = colors.fg, bg = colors.bg })
hi('NormalFloat', { fg = colors.fg, bg = colors.bg_muted })
hi('NormalNC', { fg = colors.fg_muted, bg = colors.bg })
hi('Cursor', { fg = colors.bg, bg = colors.fg })
hi('CursorLine', { bg = colors.bg_muted })
hi('CursorColumn', { link = 'CursorLine' })
hi('ColorColumn', { bg = colors.bg_muted })
hi('LineNr', { fg = colors.fg_muted })
hi('CursorLineNr', { fg = colors.accent1, style = 'bold' })
hi('SignColumn', { fg = colors.fg_muted, bg = colors.bg })
hi('Folded', { fg = colors.fg_muted, bg = colors.bg_muted })
hi('FoldColumn', { fg = colors.fg_muted, bg = colors.bg })
hi('VertSplit', { fg = colors.bg_muted })
hi('StatusLine', { fg = colors.fg, bg = colors.bg_muted })
hi('StatusLineNC', { fg = colors.fg_muted, bg = colors.bg_muted })
hi('TabLine', { fg = colors.fg_muted, bg = colors.bg_muted })
hi('TabLineFill', { bg = colors.bg_muted })
hi('TabLineSel', { fg = colors.fg, bg = colors.bg, style = 'bold' })
hi('WinBar', { fg = colors.fg, bg = colors.bg })
hi('WinBarNC', { fg = colors.fg_muted, bg = colors.bg })

-- Popup menus
hi('Pmenu', { fg = colors.fg, bg = colors.bg_muted })
hi('PmenuSel', { fg = colors.bg, bg = colors.accent1, style = 'bold' })
hi('PmenuSbar', { bg = colors.bg_muted })
hi('PmenuThumb', { bg = colors.fg_muted })

-- Search and visual
hi('Visual', { bg = colors.bg_muted })
hi('VisualNOS', { link = 'Visual' })
hi('Search', { fg = colors.bg, bg = colors.warning })
hi('IncSearch', { fg = colors.bg, bg = colors.accent1, style = 'bold' })
hi('CurSearch', { link = 'IncSearch' })
hi('Substitute', { fg = colors.bg, bg = colors.danger })

-- Messages and prompts
hi('ErrorMsg', { fg = colors.danger, style = 'bold' })
hi('WarningMsg', { fg = colors.warning, style = 'bold' })
hi('ModeMsg', { fg = colors.accent1, style = 'bold' })
hi('MoreMsg', { fg = colors.success })
hi('Question', { fg = colors.info })

-- Diff
hi('DiffAdd', { fg = colors.success, bg = colors.bg_muted })
hi('DiffChange', { fg = colors.info, bg = colors.bg_muted })
hi('DiffDelete', { fg = colors.danger, bg = colors.bg_muted })
hi('DiffText', { fg = colors.warning, bg = colors.bg_muted, style = 'bold' })

-- Spell checking
hi('SpellBad', { sp = colors.danger, style = 'undercurl' })
hi('SpellCap', { sp = colors.warning, style = 'undercurl' })
hi('SpellLocal', { sp = colors.info, style = 'undercurl' })
hi('SpellRare', { sp = colors.accent3, style = 'undercurl' })

-- Syntax highlighting
hi('Comment', { fg = colors.fg_muted, style = 'italic' })
hi('Constant', { fg = colors.accent2 })
hi('String', { fg = colors.success })
hi('Character', { link = 'String' })
hi('Number', { fg = colors.accent3 })
hi('Boolean', { fg = colors.accent2 })
hi('Float', { link = 'Number' })

hi('Identifier', { fg = colors.fg })
hi('Function', { fg = colors.accent1, style = 'bold' })

hi('Statement', { fg = colors.accent1 })
hi('Conditional', { link = 'Statement' })
hi('Repeat', { link = 'Statement' })
hi('Label', { link = 'Statement' })
hi('Operator', { fg = colors.fg })
hi('Keyword', { fg = colors.accent1, style = 'bold' })
hi('Exception', { fg = colors.danger, style = 'bold' })

hi('PreProc', { fg = colors.accent2 })
hi('Include', { link = 'PreProc' })
hi('Define', { link = 'PreProc' })
hi('Macro', { link = 'PreProc' })
hi('PreCondit', { link = 'PreProc' })

hi('Type', { fg = colors.accent2 })
hi('StorageClass', { link = 'Type' })
hi('Structure', { link = 'Type' })
hi('Typedef', { link = 'Type' })

hi('Special', { fg = colors.accent3 })
hi('SpecialChar', { link = 'Special' })
hi('Tag', { fg = colors.accent1 })
hi('Delimiter', { fg = colors.fg_muted })
hi('SpecialComment', { fg = colors.fg_muted, style = 'italic' })
hi('Debug', { fg = colors.warning })

hi('Underlined', { style = 'underline' })
hi('Ignore', { fg = colors.fg_muted })
hi('Error', { fg = colors.danger, style = 'bold' })
hi('Todo', { fg = colors.bg, bg = colors.warning, style = 'bold' })

-- LSP
hi('DiagnosticError', { fg = colors.danger })
hi('DiagnosticWarn', { fg = colors.warning })
hi('DiagnosticInfo', { fg = colors.info })
hi('DiagnosticHint', { fg = colors.accent3 })
hi('DiagnosticOk', { fg = colors.success })

hi('DiagnosticUnderlineError', { sp = colors.danger, style = 'undercurl' })
hi('DiagnosticUnderlineWarn', { sp = colors.warning, style = 'undercurl' })
hi('DiagnosticUnderlineInfo', { sp = colors.info, style = 'undercurl' })
hi('DiagnosticUnderlineHint', { sp = colors.accent3, style = 'undercurl' })
hi('DiagnosticUnderlineOk', { sp = colors.success, style = 'undercurl' })

hi('LspReferenceText', { bg = colors.bg_muted })
hi('LspReferenceRead', { link = 'LspReferenceText' })
hi('LspReferenceWrite', { link = 'LspReferenceText' })

-- Treesitter
hi('@variable', { fg = colors.fg })
hi('@variable.builtin', { fg = colors.accent2, style = 'italic' })
hi('@variable.parameter', { fg = colors.fg })
hi('@variable.member', { fg = colors.fg })

hi('@constant', { link = 'Constant' })
hi('@constant.builtin', { fg = colors.accent2, style = 'italic' })
hi('@constant.macro', { link = 'Macro' })

hi('@module', { fg = colors.accent2 })
hi('@label', { fg = colors.accent1 })

hi('@string', { link = 'String' })
hi('@string.escape', { fg = colors.accent3 })
hi('@string.special', { link = 'Special' })
hi('@character', { link = 'Character' })
hi('@number', { link = 'Number' })
hi('@boolean', { link = 'Boolean' })
hi('@float', { link = 'Float' })

hi('@function', { link = 'Function' })
hi('@function.builtin', { fg = colors.accent1, style = 'italic' })
hi('@function.macro', { link = 'Macro' })
hi('@function.call', { link = 'Function' })
hi('@constructor', { fg = colors.accent2 })

hi('@keyword', { link = 'Keyword' })
hi('@keyword.function', { link = 'Keyword' })
hi('@keyword.operator', { link = 'Keyword' })
hi('@keyword.return', { fg = colors.accent1, style = 'bold' })
hi('@keyword.conditional', { link = 'Conditional' })
hi('@keyword.repeat', { link = 'Repeat' })
hi('@keyword.exception', { link = 'Exception' })

hi('@operator', { link = 'Operator' })
hi('@type', { link = 'Type' })
hi('@type.builtin', { fg = colors.accent2, style = 'italic' })
hi('@structure', { link = 'Structure' })

hi('@punctuation.delimiter', { link = 'Delimiter' })
hi('@punctuation.bracket', { fg = colors.fg })
hi('@punctuation.special', { link = 'Special' })

hi('@comment', { link = 'Comment' })
hi('@comment.documentation', { fg = colors.fg_muted, style = 'italic' })
hi('@comment.error', { fg = colors.danger })
hi('@comment.warning', { fg = colors.warning })
hi('@comment.todo', { link = 'Todo' })
hi('@comment.note', { fg = colors.info })

hi('@markup.strong', { style = 'bold' })
hi('@markup.italic', { style = 'italic' })
hi('@markup.strikethrough', { style = 'strikethrough' })
hi('@markup.underline', { style = 'underline' })
hi('@markup.heading', { fg = colors.accent1, style = 'bold' })
hi('@markup.link', { fg = colors.info, style = 'underline' })
hi('@markup.link.url', { fg = colors.accent3 })
hi('@markup.list', { fg = colors.accent1 })
hi('@markup.quote', { fg = colors.fg_muted, style = 'italic' })
hi('@markup.raw', { fg = colors.success })

hi('@diff.plus', { link = 'DiffAdd' })
hi('@diff.minus', { link = 'DiffDelete' })
hi('@diff.delta', { link = 'DiffChange' })

hi('@tag', { link = 'Tag' })
hi('@tag.attribute', { fg = colors.accent2 })
hi('@tag.delimiter', { link = 'Delimiter' })

-- Git signs
hi('GitSignsAdd', { fg = colors.success })
hi('GitSignsChange', { fg = colors.info })
hi('GitSignsDelete', { fg = colors.danger })

-- Telescope
hi('TelescopeNormal', { fg = colors.fg, bg = colors.bg })
hi('TelescopeBorder', { fg = colors.bg_muted, bg = colors.bg })
hi('TelescopeSelection', { fg = colors.fg, bg = colors.bg_muted, style = 'bold' })
hi('TelescopeSelectionCaret', { fg = colors.accent1, bg = colors.bg_muted })
hi('TelescopeMatching', { fg = colors.accent1, style = 'bold' })

-- NvimTree
hi('NvimTreeNormal', { fg = colors.fg, bg = colors.bg })
hi('NvimTreeFolderIcon', { fg = colors.accent1 })
hi('NvimTreeFolderName', { fg = colors.accent1 })
hi('NvimTreeOpenedFolderName', { fg = colors.accent1, style = 'bold' })
hi('NvimTreeSymlink', { fg = colors.accent3 })
hi('NvimTreeGitDirty', { fg = colors.warning })
hi('NvimTreeGitNew', { fg = colors.success })
hi('NvimTreeGitDeleted', { fg = colors.danger })

-- Terminal colors
vim.g.terminal_color_0 = colors.black
vim.g.terminal_color_1 = colors.red
vim.g.terminal_color_2 = colors.green
vim.g.terminal_color_3 = colors.yellow
vim.g.terminal_color_4 = colors.blue
vim.g.terminal_color_5 = colors.magenta
vim.g.terminal_color_6 = colors.cyan
vim.g.terminal_color_7 = colors.white
vim.g.terminal_color_8 = colors.bright_black
vim.g.terminal_color_9 = colors.bright_red
vim.g.terminal_color_10 = colors.bright_green
vim.g.terminal_color_11 = colors.bright_yellow
vim.g.terminal_color_12 = colors.bright_blue
vim.g.terminal_color_13 = colors.bright_magenta
vim.g.terminal_color_14 = colors.bright_cyan
vim.g.terminal_color_15 = colors.bright_white

-- Auto-reload colorscheme when this file changes (externally by tinct)
-- Uses libuv file system event watcher to detect external modifications
local colorscheme_file = vim.fn.expand("/home/scott/.config/nvim/colors/tinct.lua")
local fs_event = vim.uv.new_fs_event()

if fs_event then
  fs_event:start(colorscheme_file, {}, vim.schedule_wrap(function(err, filename, events)
    if err then
      return
    end

    -- Debounce: wait a bit for file write to complete
    vim.defer_fn(function()
      -- Only reload if this colorscheme is currently active
      if vim.g.colors_name == "tinct" then
        vim.cmd("highlight clear")
        -- Re-source the colorscheme file
        vim.cmd("source " .. vim.fn.fnameescape(colorscheme_file))
      end
    end, 100)
  end))

  -- Clean up the watcher when Neovim exits
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      if fs_event then
        fs_event:stop()
      end
    end,
    desc = "Stop tinct colorscheme file watcher"
  })
end
