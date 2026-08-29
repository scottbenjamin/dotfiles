local layouts = {
    T  = { name = "tile",              glyph = "layout-sidebar" },
    S  = { name = "scroller",          glyph = "carousel-horizontal" },
    M  = { name = "monocle",           glyph = "square" },
    G  = { name = "grid",              glyph = "layout-grid" },
    F  = { name = "fair",              glyph = "layout-board-split" },
    D  = { name = "deck",              glyph = "layers-difference" },
    DW = { name = "dwindle",           glyph = "layout-2" },
    CT = { name = "center_tile",       glyph = "layout-distribute-vertical" },
    VT = { name = "vertical_tile",     glyph = "layout-rows" },
    RT = { name = "right_tile",        glyph = "layout-sidebar-right" },
    VS = { name = "vertical_scroller", glyph = "carousel-vertical" },
    VG = { name = "vertical_grid",     glyph = "grid-dots" },
    VD = { name = "vertical_deck",     glyph = "chart-funnel" },
    VF = { name = "vertical_fair",     glyph = "layout-board" },
}

local showGlyph = true
local showText = false
local customColor = ""
local currentSymbol = nil
local initialized = false

local function loadConfig()
    local glyphValue = noctalia.getConfig("show_glyph")
    showGlyph = glyphValue == true or glyphValue == "true" or glyphValue == nil

    local textValue = noctalia.getConfig("show_text")
    showText = textValue == true or textValue == "true"
    customColor = noctalia.getConfig("custom_color") or ""
end

local function render(symbol)
    local current = layouts[symbol]

    if current then
        if showGlyph then
            barWidget.setGlyph(current.glyph)
        else
            barWidget.setGlyph("")
        end

        if showText then
            barWidget.setText(noctalia.tr("name_" .. current.name))
        else
            barWidget.setText("")
        end

        barWidget.setTooltip(noctalia.tr("name_" .. current.name))
    else
        barWidget.setGlyph(if showGlyph then "layout" else "")
        barWidget.setText(if showText then "Layout" else "")
        barWidget.setTooltip("Mango layout")
    end

    if customColor ~= "" then
        barWidget.setColor(customColor)
        barWidget.setGlyphColor(customColor)
    end
end

local function setLayout(symbol)
    if symbol == nil then return end
    local clean = symbol:gsub("%s+", "")
    if clean == "" then return end
    currentSymbol = clean
    render(currentSymbol)
end

-- Query once when the widget is created. Further updates are pushed by the
-- Mango IPC watcher instead of spawning mmsg and jq every second.
function update()
    if initialized then return end
    initialized = true
    loadConfig()

    noctalia.runAsync(
        "mmsg get all-monitors | jq -r '.monitors[] | select(.active == true) | .layout_symbol'",
        function(result)
            if result and result.exitCode == 0 then
                setLayout(result.stdout)
            end
        end
    )
end

function onIpc(event, payload)
    if event == "set-layout" then
        setLayout(payload)
    end
end

function onClick()
    noctalia.togglePanel("scott/mango_layouts:panel")
end

function onConfigChanged()
    loadConfig()
    render(currentSymbol)
end
