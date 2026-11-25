local save = require("runtime.save.init")
local const = require("shared.constants")
local registry = require("runtime.gui.registry")

---@class GuiTemplate.Context.Fields
---@field element LuaGuiElement
---@field template GuiTemplate?

---@class GuiTemplate.Context: GuiTemplate.Context.Fields
---@field template GuiTemplate
local class = {}
class.__index = class

---@type fun(fields: GuiTemplate.Context.Fields): GuiTemplate.Context
function class.new(fields)
	local instance = fields --[[@as GuiTemplate.Context]]

	if not instance.template then
		local templateId = fields.element.tags.template
		instance.template = registry.templates[templateId]

		if not templateId or not instance.template then
			error("Unable to create context from template id: " .. templateId .. "\nelement: " .. fields.element.name)
		end
	end

	return setmetatable(instance, class)
end

---@type fun(self: GuiTemplate.Context): Save.Player.Entry
function class:playerEntry()
	local index = self.element.player_index
	local player = save.players.get(index)

	if not player then
		error("Unable to get player entry by index: " .. index)
	end

	return player
end

---@type fun(
---self: GuiTemplate.Context,
---template: GuiTemplate,
---filter: GuiTemplate.Overrides)
---: GuiTemplate.Context?
function class:getElement(template, filter)
	return nil
end

return class
