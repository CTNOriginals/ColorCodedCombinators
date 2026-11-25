local events = require("runtime.eventHandler")
local save = require("runtime.save.init")
local registry = require("runtime.gui.registry")

local M = {
	ui = {
		colorTool = require("runtime.gui.colorTool.init"),
	},
}

---@class OnGuiEvent.Data: EventData
---@field element LuaGuiElement?
---@field player_index uint

for name, gui in pairs(M.ui) do
	for key, template in pairs(gui.templates) do
		template.id = name .. "." .. key
		registry.templates[template.id] = template
		log(template.id .. ": " .. template.definition.type)

		if template.events then
			for eventType, fn in pairs(template.events) do
				---@type fun(event: OnGuiEvent.Data)
				local handler = function(event)
					if not event.element.valid or event.element.tags.template ~= template.id then
						return
					end

					local entry = save.players.get(event.player_index)

					if not entry or not entry.player.valid then
						log("Invalid player entry or id: " .. event.player_index)
						return
					end

					-- log(eventType .. ": " .. event.name .. " " .. event.element.name)
					fn(event, template:context(event.element))
				end

				log(eventType)
				events.register(defines.events[eventType], handler)
			end
		end
	end
end

---@param event OnGuiEvent.Data
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
