local events = require("runtime.eventHandler")
local templateClass = require("runtime.gui.templateClass")

local M = {
	ui = {
		colorTool = require("runtime.gui.colorTool.init"),
	},
}

---@type table<string, GuiTemplate>
M.templateRegistry = {}

for name, gui in pairs(M.ui) do
	for key, template in pairs(gui.templates) do
		template.id = name .. "." .. key
		M.templateRegistry[template.id] = template
	end
end

---@param event OnGuiEvents
local function handleGuiEvent(event)
	for _, module in pairs(M.ui) do
		if module.handlers and module.handlers[event.element.name] then
			module.handlers[event.element.name](event)
		end
	end
end

events.register(defines.events.on_gui_click, handleGuiEvent)
events.register(defines.events.on_gui_value_changed, handleGuiEvent)
events.register(defines.events.on_gui_text_changed, handleGuiEvent)

return M
