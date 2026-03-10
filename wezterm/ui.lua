local wezterm = require("wezterm")
local M = {}

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
