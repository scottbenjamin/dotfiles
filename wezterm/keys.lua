local wezterm = require("wezterm")
local act = wezterm.action
local window = wezterm.window

local stuff = {}

stuff.keys = {
	{
		key = "o",
		mods = "CTRL|SHIFT",
		action = act.PaneSelect({
			alphabet = "asdfjkl;",
		}),
	},

	-- Resizing KeyTable
	{
		key = "r",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "resize_pane",
			one_shot = false,
		}),
	},
}

stuff.key_tables = {
	resize_pane = {
		{ key = "k", action = act.AdjustPaneSize({ "Up", 10 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 10 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 10 }) },
		{ key = "h", action = act.AdjustPaneSize({ "Left", 10 }) },

		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },
	},
}

return stuff
