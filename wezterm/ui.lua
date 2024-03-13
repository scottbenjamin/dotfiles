local wezterm = require("wezterm")
local M = {}

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- default title.
function M.tab_title(tab)
	local title = tab.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the default title.
	return " " .. tostring(tab.tab_index + 1) .. " "
end

wezterm.on("format-tab-title", function(tab, _, _, _, _, _)
	local solid_left_arrow = wezterm.nerdfonts.ple_lower_right_triangle
	local solid_right_arrow = wezterm.nerdfonts.ple_upper_left_triangle
	-- local solid_right_arrow = wezterm.nerdfonts.pl_left_hard_divider
	local bg_color = "#222436"
	local bg_active_color = "#2f334d"
	local fg_color = "#c8d3f5"
	local fg_active_color = "#82aaff"

	-- Edge icon color
	local edge_icon_bg = bg_color
	local edge_icon_fg = bg_color

	-- Inactive tab
	local tab_bg_color = bg_active_color
	local tab_fg_color = fg_color

	if tab.is_active then
		tab_bg_color = fg_active_color
		tab_fg_color = bg_color
	end

	edge_icon_fg = tab_bg_color
	local title = M.tab_title(tab)

	return {
		{ Background = { Color = edge_icon_bg } },
		{ Foreground = { Color = edge_icon_fg } },
		{ Text = solid_left_arrow },
		{ Background = { Color = tab_bg_color } },
		{ Foreground = { Color = tab_fg_color } },
		{ Text = title },
		{ Background = { Color = edge_icon_bg } },
		{ Foreground = { Color = edge_icon_fg } },
		{ Text = solid_right_arrow },
	}
end)

function M.update_right_status_bar()
	wezterm.on("update-right-status", function(window, pane)
		-- Each element holds the text for a cell in a "powerline" style << fade
		local cells = {}

		-- Figure out the cwd and host of the current pane.
		-- This will pick up the hostname for the remote host if your
		-- shell is using OSC 7 on the remote host.
		-- local cwd_uri = pane:get_current_working_dir()
		-- if cwd_uri then
		-- 	local cwd = ""
		-- 	local hostname = ""
		--
		-- 	if type(cwd_uri) == "userdata" then
		-- 		-- Running on a newer version of wezterm and we have
		-- 		-- a URL object here, making this simple!
		--
		-- 		cwd = cwd_uri.file_path
		-- 		hostname = cwd_uri.host or wezterm.hostname()
		-- 	else
		-- 		-- an older version of wezterm, 20230712-072601-f4abf8fd or earlier,
		-- 		-- which doesn't have the Url object
		-- 		cwd_uri = cwd_uri:sub(8)
		-- 		local slash = cwd_uri:find("/")
		-- 		if slash then
		-- 			hostname = cwd_uri:sub(1, slash - 1)
		-- 			-- and extract the cwd from the uri, decoding %-encoding
		-- 			cwd = cwd_uri:sub(slash):gsub("%%(%x%x)", function(hex)
		-- 				return string.char(tonumber(hex, 16))
		-- 			end)
		-- 		end
		-- 	end
		--
		-- 	-- Remove the domain name portion of the hostname
		-- 	local dot = hostname:find("[.]")
		-- 	if dot then
		-- 		hostname = hostname:sub(1, dot - 1)
		-- 	end
		-- 	if hostname == "" then
		-- 		hostname = wezterm.hostname()
		-- 	end
		--
		-- 	table.insert(cells, cwd)
		-- 	table.insert(cells, hostname)
		-- end

		-- I like my date/time in this style: "Wed Mar 3 08:14"
		local date = wezterm.strftime("%a %b %-d %H:%M:%S")
		table.insert(cells, date)

		-- An entry for each battery (typically 0 or 1 battery)
		for _, b in ipairs(wezterm.battery_info()) do
			table.insert(cells, string.format("%.0f%%", b.state_of_charge * 100))
		end

		-- The powerline < symbol
		local LEFT_ARROW = utf8.char(0xe0b3)
		-- The filled in variant of the < symbol
		local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

		-- Color palette for the backgrounds of each cell
		local colors = {
			"#3c1361",
			"#52307c",
			"#663a82",
			"#7c5295",
			"#b491c8",
		}

		-- Foreground color for the text across the fade
		local text_fg = "#ECE1D7"

		-- The elements to be formatted
		local elements = {}
		-- How many cells have been formatted
		local num_cells = 0

		-- Translate a cell into elements
		function push(text, is_last)
			local cell_no = num_cells + 1
			table.insert(elements, { Foreground = { Color = text_fg } })
			table.insert(elements, { Background = { Color = colors[cell_no] } })
			table.insert(elements, { Text = " " .. text .. " " })
			if not is_last then
				table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
				table.insert(elements, { Text = SOLID_LEFT_ARROW })
			end
			num_cells = num_cells + 1
		end

		while #cells > 0 do
			local cell = table.remove(cells, 1)
			push(cell, #cells == 0)
		end

		window:set_right_status(wezterm.format(elements))
	end)
end

function M.append(config)
	local options = {
		default_cursor_style = "BlinkingBar", -- default: 'SteadyBlock'
		-- font_size = 22, -- default: 12.0
		-- font = wezterm.font_with_fallback({ "JetBrainsMono Nerd Font", "Noto Color Emoji" }),
		--
		-- color_scheme = "catppuccin_mocha",

		scrollback_lines = 10000, --defauls: 3500

		-- Padding
		-- Tab bar can't have padding https://github.com/wez/wezterm/issues/3077
		window_padding = { left = 3, right = 3, top = 3, bottom = 3 },

		-- Tab Bar Options
		-- GTK tab-bar is looking awful.
		use_fancy_tab_bar = false, -- default: true

		-- Hiding the tab-bar also means hiding the right status
		-- Means you lose viseal feedback of sticky keys.
		-- It is better to set it to `false`
		hide_tab_bar_if_only_one_tab = false, -- default: false

		inactive_pane_hsb = {
			saturation = 0.70,
			brightness = 0.70,
		},
	}

	for key, value in pairs(options) do
		config[key] = value
	end
end

return M
