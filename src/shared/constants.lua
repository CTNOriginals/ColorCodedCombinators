---@alias CombinatorType 'decider' | 'arithmetic' | 'selector' | 'constant'

---@alias OnGuiEvents EventData.on_gui_value_changed
---| EventData.on_gui_text_changed
---| EventData.on_gui_click

local M = {}

M.prefix = "ccc-"

-- Combinators

---@type CombinatorType[]
M.combinatorTypes = { "decider", "arithmetic", "selector", "constant" }

---Vanilla entity name per combinator type
---@type {[CombinatorType]: string}
M.combinatorEntities = {}
for _, type in ipairs(M.combinatorTypes) do
	M.combinatorEntities[type] = type .. "-combinator"
end

-- Directions

M.directionNames = { "north", "east", "south", "west" }

---@type {[defines.direction]: string}
M.directionToName = {}
for _, name in ipairs(M.directionNames) do
	M.directionToName[defines.direction[name]] = name
end

-- Shortcut

M.shortcut = {}
M.shortcut.tool = M.prefix .. "color-tool"
M.shortcut.input = M.shortcut.tool .. "-input"
M.shortcut.name = M.shortcut.tool .. "-shortcut"

-- GUI

M.gui = {}
M.gui.prefix = M.prefix .. "gui-"
M.gui.colorTool = M.gui.prefix .. "color-tool"
M.gui.sliderStyle = M.gui.prefix .. "slider"

-- Meta

M.metatables = {}
M.metatables.prefix = M.prefix .. "metatables"
M.metatables.names = {}
M.metatables.names.guiTemplate = M.metatables.prefix .. "gui-template"

-- Dev

M.reloadPayload = M.prefix .. "reload"

return M
