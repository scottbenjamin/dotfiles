local wezterm = require("wezterm")
local mux = wezterm.mux

local k = require("keys")
local ui = require("ui")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.default_workspace = "main"
config.default_domain = "unix"

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

-- LEADER KEY
-- Show which key table is active in the status area
-- config.leader = { key = "s", mods = "CTRL", timeout_milliseconds = 1000 }

-- Key binds
-- config.keys = k.keys
config.keys = {}
config.key_tables = k.key_tables

-- Behavior
config.exit_behavior = "Close"

-- Check for updates
config.check_for_updates = true
config.check_for_updates_interval_seconds = 86400

-- Domain - disabled due to https://github.com/wez/wezterm/issues/4102
-- config.unix_domains = { { name = "unix", local_echo_threshold_ms = 10 }, }
-- config.default_gui_startup_args = { "connect", "unix" }

-- Add UI specific changes
ui.append(config)

-- and finally, return the configuration to wezterm
-- Integrate with neovim smart-splits plugin
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

-- you can put the rest of your Wezterm config here
smart_splits.apply_to_config(config, {
	-- the default config is here, if you'd like to use the default keys,
	-- you can omit this configuration table parameter and just use
	-- smart_splits.apply_to_config(config),

	-- directional keys to use in order of: left, down, up, right
	direction_keys = { "h", "j", "k", "l" },
	-- modifier keys to combine with direction_keys
	modifiers = {
		move = "CTRL|SHIFT", -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = "CTRL|META", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
})

return config

-- vim: ts=4 sts=2 sw=2 et
