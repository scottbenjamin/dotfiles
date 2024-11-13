local wezterm = require("wezterm")
local M = {}

-- -- This function returns the suggested title for a tab.
-- -- It prefers the title that was set via `tab:set_title()`
-- -- or `wezterm cli set-tab-title`, but falls back to the
-- -- default title.
-- local function tab_title(tab)
-- 	local title = tab.tab_title
-- 	local tab_index = tostring(tab.tab_index + 1)
-- 	-- if the tab title is explicitly set, take that
-- 	if title and #title > 0 then
-- 		return tab_index .. ":" .. title
-- 	end
-- 	-- Otherwise, use the default title.
-- 	return " " .. tostring(tab.tab_index + 1) .. " "
-- end
--
-- wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
-- 	local title = tab_title(tab)
-- 	if tab.is_active then
-- 		return {
-- 			{ Foreground = { Color = "#c0caf5" } },
-- 			{ Text = " " .. title .. " " },
-- 		}
-- 	end
-- 	return title
-- end)
--
-- wezterm.on("update-status", function(window, pane)
-- 	-- Workspace name
-- 	local stat = window:active_workspace()
-- 	local stat_color = "#c0caf5"
--
-- 	-- Utilize this to display LDR or current key table name
-- 	if window:active_key_table() then
-- 		stat = window:active_key_table()
-- 		-- stat_color = "#7dcfff"
-- 		stat_color = "#c0caf5"
-- 	end
-- 	if window:leader_is_active() then
-- 		stat = "LDR"
-- 		stat_color = "#bb9af7"
-- 	end
--
-- 	local basename = function(s)
-- 		-- Nothing a little regex can't fix
-- 		return string.gsub(s, "(.*[/\\])(.*)", "%2")
-- 	end
--
-- 	-- Current working directory
-- 	local cwd = pane:get_current_working_dir()
-- 	if cwd then
-- 		if type(cwd) == "userdata" then
-- 			-- Wezterm introduced the URL object in 20240127-113634-bbcac864
-- 			cwd = basename(cwd.file_path)
-- 		else
-- 			cwd = basename(cwd)
-- 		end
-- 	else
-- 		cwd = ""
-- 	end
--
-- 	-- Current command
-- 	local cmd = pane:get_foreground_process_name()
-- 	-- CWD and CMD could be nil (e.g. viewing log using Ctrl-Alt-l)
-- 	cmd = cmd and basename(cmd) or ""
--
-- 	-- Time
-- 	local time = wezterm.strftime(" %Y.%m.%d %H:%M:%S")
--
-- 	-- Left status (left of the tab line)
-- 	window:set_left_status(wezterm.format({
-- 		{ Foreground = { Color = stat_color } },
-- 		{ Text = "  " },
-- 		{ Text = wezterm.nerdfonts.oct_table .. "  " .. stat },
-- 		{ Text = " |" },
-- 	}))
--
-- 	-- Right status
-- 	window:set_right_status(wezterm.format({
-- 		-- Wezterm has a built-in nerd fonts
-- 		-- https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
-- 		{ Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
-- 		{ Text = " | " },
-- 		{ Foreground = { Color = "#e0af68" } },
-- 		{ Text = wezterm.nerdfonts.fa_code .. "  " .. cmd },
-- 		"ResetAttributes",
-- 		{ Text = " | " },
-- 		{ Text = wezterm.nerdfonts.md_clock .. "  " .. time },
-- 		{ Text = "  " },
-- 	}))
-- end)

-- UI Config
function M.append(config)
	local options = {

		default_cursor_style = "BlinkingBar", -- default: 'SteadyBlock'
		font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Medium" }), -- Font
		font_size = 12.5, -- Font Size

		-- Set the color theme
		color_scheme_dirs = { "$HOME/.config/wezterm/colors" },

		-- color_scheme = "melange_dark"
		-- color_scheme = "Catppuccin Macchiato"
		color_scheme = "Tokyo Night Storm",
		-- color_scheme = "Kanagawa (Gogh)",

		scrollback_lines = 50000, --defauls: 3500

		-- Padding
		-- Tab bar can't have padding https://github.com/wez/wezterm/issues/3077
		window_padding = { left = 3, right = 3, top = 3, bottom = 2 },

		-- Hiding the tab-bar also means hiding the right status
		-- Means you lose viseal feedback of sticky keys.
		-- It is better to set it to `false`
		use_fancy_tab_bar = false, -- default: true
		hide_tab_bar_if_only_one_tab = true, -- default: false

		inactive_pane_hsb = {
			saturation = 0.90,
			brightness = 0.40,
		},

		-- Window Size
		initial_cols = 110,
		initial_rows = 70,

		-- Window decorations
		window_decorations = "RESIZE",
		window_close_confirmation = "AlwaysPrompt",
		audible_bell = "Disabled",

		window_background_opacity = 0.9,
		macos_window_background_blur = 40,
		bold_brightens_ansi_colors = true,
	}

	for key, value in pairs(options) do
		config[key] = value
	end
end

return M
-- vim: ts=4 sts=2 sw=2 et
