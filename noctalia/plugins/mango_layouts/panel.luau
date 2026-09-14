local layouts = {
	{ sym = "T",  name = "tile",             glyph = "layout-sidebar" },
	{ sym = "S",  name = "scroller",         glyph = "carousel-horizontal" },
	{ sym = "M",  name = "monocle",          glyph = "square" },
	{ sym = "G",  name = "grid",             glyph = "layout-grid" },
	{ sym = "F",  name = "fair",             glyph = "layout-board-split" },
	{ sym = "K",  name = "deck",             glyph = "layers-difference" },
	{ sym = "DW", name = "dwindle",          glyph = "layout-2" },
	{ sym = "CT", name = "center_tile",      glyph = "layout-distribute-vertical" },
	{ sym = "VT", name = "vertical_tile",    glyph = "layout-rows" },
	{ sym = "RT", name = "right_tile",       glyph = "layout-sidebar-right" },
	{ sym = "VS", name = "vertical_scroller",glyph = "carousel-vertical" },
	{ sym = "VG", name = "vertical_grid",    glyph = "grid-dots" },
	{ sym = "VK", name = "vertical_deck",    glyph = "chart-funnel" },
	{ sym = "VF", name = "vertical_fair",    glyph = "layout-board" },
}

local COLUMNS = 4
local COLUMN_GAP = 2
local selectedLayout = ""

local render

local function firstSymbol(raw)
	if raw == nil then return "" end
	return raw:match("^%s*(%S+)") or ""
end

local function applyLayout(entry)
	selectedLayout = entry.sym
	noctalia.runAsync("mmsg dispatch setlayout," .. entry.name)
	-- Don't wait on layout-watch: the bar widget is event-driven and will
	-- otherwise keep showing the previous layout (usually dwindle).
	noctalia.runAsync(
		"noctalia msg plugin scott/mango_layouts:btn all set-layout " .. entry.sym
	)
	panel.close()
end

local function makeGrid(children)
	local rows = {}
	local row  = {}
	for i, child in ipairs(children) do
		table.insert(row, child)
		if #row >= COLUMNS or i == #children then
			while #row < COLUMNS do
				table.insert(row, ui.spacer({ flexGrow = 1 }))
			end
			table.insert(rows, ui.row({ gap = COLUMN_GAP, align = "stretch" }, row))
			row = {}
		end
	end
	return ui.column({ gap = COLUMN_GAP }, rows)
end

local function getShowConfig(name)
	if name == "tile" then return noctalia.getConfig("show_tile") end
	if name == "scroller" then return noctalia.getConfig("show_scroller") end
	if name == "monocle" then return noctalia.getConfig("show_monocle") end
	if name == "grid" then return noctalia.getConfig("show_grid") end
	if name == "fair" then return noctalia.getConfig("show_fair") end
	if name == "deck" then return noctalia.getConfig("show_deck") end
	if name == "dwindle" then return noctalia.getConfig("show_dwindle") end
	if name == "center_tile" then return noctalia.getConfig("show_center_tile") end
	if name == "vertical_tile" then return noctalia.getConfig("show_vertical_tile") end
	if name == "right_tile" then return noctalia.getConfig("show_right_tile") end
	if name == "vertical_scroller" then return noctalia.getConfig("show_vertical_scroller") end
	if name == "vertical_grid" then return noctalia.getConfig("show_vertical_grid") end
	if name == "vertical_deck" then return noctalia.getConfig("show_vertical_deck") end
	if name == "vertical_fair" then return noctalia.getConfig("show_vertical_fair") end
	return true
end

local function renderButtons(is_list_mode)
	local buttons = {}
	for _, entry in ipairs(layouts) do
		local raw_val = getShowConfig(entry.name)
		local enabled = (raw_val == true) or (raw_val == "true") or (raw_val == nil)

		if enabled then
			local isSelected = selectedLayout == entry.sym
			local onPick = function()
				applyLayout(entry)
			end

			if is_list_mode then
				table.insert(buttons, ui.button({
					key       = entry.sym,
					glyph     = entry.glyph,
					text      = noctalia.tr("name_" .. entry.name),
					variant   = if isSelected then "primary" else "ghost",
					onClick   = onPick,
				}))
			else
				table.insert(buttons, ui.column({
					key      = entry.sym,
					gap      = 2,
					align    = "center",
					flexGrow = 1,
					onClick  = onPick,
				}, {
					ui.button({
						glyph   = entry.glyph,
						glyphSize = 18,
						variant = if isSelected then "primary" else "ghost",
						onClick = onPick,
					}),
					ui.label({
						text      = noctalia.tr("name_" .. entry.name),
						fontSize  = 9,
						fontWeight = "bold",
						color     = if isSelected then "primary" else "on_surface_variant",
						textAlign = "center",
						maxLines  = 1,
					}),
				}))
			end
		end
	end
	return buttons
end

render = function()
	local list_mode_raw = noctalia.getConfig("list_mode")
	local is_list_mode = (list_mode_raw == true) or (list_mode_raw == "true")

	local content
	if is_list_mode then
		content = ui.column({ padding = 8, gap = 4 }, renderButtons(true))
	else
		content = ui.column({ padding = 12, gap = COLUMN_GAP }, {
			makeGrid(renderButtons(false))
		})
	end

	panel.render(ui.column({ flexGrow = 1 }, {
		ui.scroll({ flexGrow = 1 }, {
			content
		})
	}))
end

function onOpen(context)
	selectedLayout = ""
	render()
	noctalia.runAsync(
		"mmsg get all-monitors | jq -r '[.monitors[] | select(.active == true) | .layout_symbol] | first // empty'",
		function(result)
			if result == nil or result.exitCode ~= 0 then return end
			local sym = firstSymbol(result.stdout)

			local exists = false
			for _, l in ipairs(layouts) do
				if l.sym == sym then exists = true end
			end
			selectedLayout = if exists then sym else ""
			render()
		end
	)
end
