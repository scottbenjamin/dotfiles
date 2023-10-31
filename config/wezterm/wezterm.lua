-- Pull in the wezterm API
local wezterm = require("wezterm")
local k = require("keys")

-- This table will hold the configuration.
local config = {}

wezterm.on("update-right-status", function(window, pane)
	local name = window:active_key_table()
	if name then
		name = "TABLE: " .. name
	end
	window:set_right_status(name or "")
end)

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.use_ime = false

-- Font
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular", stretch = "Normal", style = "Normal" })

-- Font Size
config.font_size = 12

config.initial_cols = 110
config.initial_rows = 50

-- No Audible bell please
config.audible_bell = "Disabled"

config.window_background_opacity = 0.9
-- config.text_background_opacity = 0.3
config.macos_window_background_blur = 30
config.bold_brightens_ansi_colors = true

config.enable_tab_bar = false

-- For example, changing the color scheme:
config.color_scheme_dirs = { "$HOME/.config/wezterm/colors" }

-- config.color_scheme = "Tokyo Night Storm (Gogh)"
-- config.color_scheme = "Kanagawa (Gogh)"
config.color_scheme = "Melange Dark"

-- KEY
-- Show which key table is active in the status area
config.leader = { key = "Space", mods = "CTRL|ALT" }
config.keys = k.keys
config.key_tables = k.key_tables

-- and finally, return the configuration to wezterm
return config
