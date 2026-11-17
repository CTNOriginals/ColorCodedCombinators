local const = require("constants")

local M = {
	colorTool = require("gui.colorTool"),
}

function handleGuiEvent(event)
	for key, module in pairs(M) do
		if not module.handlers or not module.handlers[event.element.name] then
			return
		end

		module.handlers[event.element.name](event)
	end
end
-- script.on_event(defines.events.on_gui_click, M.onClick)
script.on_event(defines.events.on_gui_value_changed, handleGuiEvent)
script.on_event(defines.events.on_gui_text_changed, handleGuiEvent)

return M
