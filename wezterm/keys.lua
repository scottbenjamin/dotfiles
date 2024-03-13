local wezterm = require("wezterm")
local act = wezterm.action

local function tab_keys()
	local mykeys = {}

	for i = 1, 9 do
		table.insert(mykeys, { key = tostring(i), mods = "LEADER", action = act.ActivateTab(i - 1) })
	end

	return mykeys
end

local stuff = {}

stuff.keys = {
	-- Pane selection
	{ key = "o", mods = "LEADER", action = act.PaneSelect({ alphabet = "asdfjkl;" }) },

	-- Splits
	{ key = "5", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "'", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{
		key = "p",
		mods = "LEADER|",
		action = act.SplitPane({
			direction = "Right",
			size = { Percent = 35 },
		}),
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

	-- maximize window
	-- {keys = 'M', mods = 'SHIFT|LEADER', action = act}

	-- Show items
	{ key = "l", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|TABS|DOMAINS|WORKSPACES" }) },

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
}

-- Merge progamatically created tables with static table
for k, v in pairs(tab_keys()) do
	-- 	stuff.keys[k] = v
	print(v)
end
--
stuff.key_tables = {}

return stuff

-- vim: ts=4 sts=2 sw=2 et
