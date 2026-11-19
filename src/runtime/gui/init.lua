local events = require("runtime.eventHandler")

local M = {
	colorTool = require("runtime.gui.colorTool"),
}

---@param event EventData.on_gui_click | EventData.on_gui_value_changed | EventData.on_gui_text_changed
local function handleGuiEvent(event)
	for _, module in pairs(M) do
		if module.handlers and module.handlers[event.element.name] then
			module.handlers[event.element.name](event)
		end
	end
end

events.register(defines.events.on_gui_click, handleGuiEvent)
events.register(defines.events.on_gui_value_changed, handleGuiEvent)
events.register(defines.events.on_gui_text_changed, handleGuiEvent)

return M
