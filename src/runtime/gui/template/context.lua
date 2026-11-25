local save = require("runtime.save.init")
local const = require("shared.constants")
local registry = require("runtime.gui.registry")

---@class GuiTemplate.Context.Fields
---@field element LuaGuiElement
---@field template GuiTemplate?
---@field playerEntry Save.Player.Entry?

---@class GuiTemplate.Context: GuiTemplate.Context.Fields
---@field template GuiTemplate
---@field playerEntry Save.Player.Entry
local class = {}
class.__index = class

---@type fun(fields: GuiTemplate.Context.Fields): GuiTemplate.Context
function class.new(fields)
	local instance = fields

	local fatal = function(message)
		error("\nFaild to create context for element: " .. fields.element.name .. "\n" .. message, 2)
	end

	if not instance.template then
		local templateId = fields.element.tags.template
		instance.template = registry.templates[templateId]

		if not templateId or not instance.template then
			fatal("Invalid template id: " .. templateId)
		end
	end

	if not instance.playerEntry then
		local index = fields.element.player_index
		instance.playerEntry = save.players.get(index)

		if not instance.playerEntry then
			fatal("Unable to get player entry from index: " .. index)
		end
	end

	return setmetatable(instance --[[@as GuiTemplate.Context]], class)
end

---@type fun(self: GuiTemplate.Context): GuiTemplate.Context
function class:getRoot()
	local current = self.element
	local next = current.parent

	while next and next.get_mod() == const.name do
		current = next
		next = current.parent
	end

	return class.new({
		element = current,
	})
end

---@type fun(
---self: GuiTemplate.Context,
---template: GuiTemplate,
---filter: GuiTemplate.Overrides)
---: GuiTemplate.Context?
function class:getElement(template, filter)
	log(serpent.line(self:getRoot()))
	return nil
end

return class
