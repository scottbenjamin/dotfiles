local wezterm = require("wezterm")
local act = wezterm.action
local M = {}

M.keys = {
	-- Pane selection
	{ key = "o", mods = "LEADER", action = act.PaneSelect({ alphabet = "asdfjkl;" }) },
	--
	-- -- Splits
	{ key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{
		key = "V",
		mods = "LEADER",
		command = { arg = "/bin/zsh" },
		action = act.SplitPane({ direction = "Right", size = { Percent = 30 } }),
	},
	{ key = "h", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{
		key = "H",
		mods = "LEADER",
		command = { arg = "/bin/zsh" },
		action = act.SplitPane({ direction = "Down", size = { Percent = 30 } }),
	},

	-- Zoom Pane
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	-- rotate panes
	{ key = "Space", mods = "LEADER", action = act.RotatePanes("Clockwise") },

	-- show the pane selection mode, but have it swap the active and selected panes
	{ key = "0", mods = "LEADER", action = act.PaneSelect({ mode = "SwapWithActive" }) },

	-- activate copy mode or vim mode
	{ key = "Enter", mods = "LEADER", action = act.ActivateCopyMode },

	-- Tab movement
	{ key = "]", mods = "LEADER", action = act.MoveTabRelative(1) },
	{ key = "[", mods = "LEADER", action = act.MoveTabRelative(-1) },

	-- Show tab navigator
	{ key = "t", mods = "LEADER", action = act.ShowTabNavigator },

	-- Spawn new tab
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "q", mods = "LEADER", action = act.QuickSelect },

	-- Close pane
	{
		key = "x",
		mods = "LEADER",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},

	-- Show items
	{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	{ key = "t", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|TABS" }) },

	-- Rename tab
	{
		key = ",",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{
		key = "<",
		mods = "LEADER|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for session:",
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
				end
			end),
		}),
	},

	-- Resize Panes mode
	{
		key = "r",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "resize_pane",
			one_shot = false,
		}),
	},
	-- Disable some keys we hit by mistake
	{
		key = "m",
		mods = "CMD",
		action = wezterm.action.DisableDefaultAssignment,
	},
	{
		key = "h",
		mods = "CMD",
		action = wezterm.action.DisableDefaultAssignment,
	},
}

-- Create keymaps for 'LEADER + 1-9' to change to appropriate tabs
for i = 1, 9 do
	table.insert(M.keys, { key = tostring(i), mods = "LEADER", action = act.ActivateTab(i - 1) })
end

--
local resize_amount = 3
M.key_tables = {
	-- Defines the keys that are active in our resize-pane mode.
	-- Since we're likely to want to make multiple adjustments,
	-- we made the activation one_shot=false. We therefore need
	-- to define a key assignment for getting out of this mode.
	-- 'resize_pane' here corresponds to the name="resize_pane" in
	-- the key assignments above.

	resize_pane = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", resize_amount }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", resize_amount }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", resize_amount }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", resize_amount }) },

		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },
	},

	-- Defines the keys that are active in our activate-pane mode.
	-- 'activate_pane' here corresponds to the name="activate_pane" in
	-- the key assignments above.
	activate_pane = {
		{ key = "h", action = act.ActivatePaneDirection("Left") },
		{ key = "l", action = act.ActivatePaneDirection("Right") },
		{ key = "k", action = act.ActivatePaneDirection("Up") },
		{ key = "j", action = act.ActivatePaneDirection("Down") },
	},
}

return M

-- vim: ts=4 sts=2 sw=2 et
