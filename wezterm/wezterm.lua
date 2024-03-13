local wezterm = require("wezterm")
local mux = wezterm.mux

local k = require("keys")
local ui = require("ui")

local state = {
	debug_mode = false,
}

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- https://wezfurlong.org/wezterm/config/lua/gui-events/gui-startup.html
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

-- Use the gpu
local gpus = wezterm.gui.enumerate_gpus()

config.webgpu_preferred_adapter = gpus[1]
config.front_end = "WebGpu"

config.use_ime = false

-- Font
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Medium" })
-- config.font = wezterm.font("Hack Nerd Font", { weight = "Medium" })

-- Font Size
config.font_size = 13

-- Window Size
config.initial_cols = 110
config.initial_rows = 70
config.window_padding = {
	left = 2,
	right = 2,
	top = 2,
	bottom = 0,
}

-- Window decorations
config.window_decorations = "RESIZE"
config.default_cursor_style = "BlinkingBar"

-- No Audible bell please
config.audible_bell = "Disabled"

config.scrollback_lines = 3500
config.enable_scroll_bar = false

config.window_background_opacity = 0.9
-- config.text_background_opacity = 0.3
--
config.macos_window_background_blur = 30
config.bold_brightens_ansi_colors = true

-- config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = true
config.show_tabs_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false

-- For example, changing the color scheme:
config.color_scheme_dirs = { "$HOME/.config/wezterm/colors" }

-- Set the color theme
config.color_scheme = "melange_dark"
-- config.color_scheme = "Catppuccin Macchiato"

-- LEADER KEY
-- Show which key table is active in the status area
config.leader = { key = "s", mods = "CTRL|ALT", timeout_milliseconds = 1000 }

-- Key binds
config.keys = k.keys
config.key_tables = k.key_tables

-- Behavior
config.exit_behavior = "Close"

-- Check for updates
config.check_for_updates = true
config.check_for_updates_interval_seconds = 86400

-- Domain
config.unix_domains = {
	{ name = "unix" },
}

-- Status bar
-- ui.append(config)

-- -- and finally, return the configuration to wezterm
-- -- Integrate with neovim smart-splits plugin
-- local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
--
-- -- you can put the rest of your Wezterm config here
-- smart_splits.apply_to_config(config, {
-- 	-- the default config is here, if you'd like to use the default keys,
-- 	-- you can omit this configuration table parameter and just use
-- 	-- smart_splits.apply_to_config(config)
--
-- 	-- directional keys to use in order of: left, down, up, right
-- 	direction_keys = { "h", "j", "k", "l" },
-- 	-- modifier keys to combine with direction_keys
-- 	modifiers = {
-- 		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
-- 		resize = "CTRL|META", -- modifier to use for pane resize, e.g. META+h to resize to the left
-- 	},
-- })

return config

-- vim: ts=4 sts=2 sw=2 et
