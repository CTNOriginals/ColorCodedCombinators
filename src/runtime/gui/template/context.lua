local save = require("runtime.save.init")
local const = require("shared.constants")
local registry = require("runtime.gui.registry")
local utils = require("shared.utils")

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
		playerEntry = self.playerEntry,
	})
end

---@type fun(self: GuiTemplate.Context, fn: fun(ctx: GuiTemplate.Context))
function class:walk(fn)
	fn(self)

	for _, child in pairs(self.element.children) do
		local ctx = class.new({
			element = child,
			playerEntry = self.playerEntry,
		})

		ctx:walk(fn)
	end
end

---@type fun(self: GuiTemplate.Context, filter: GuiTemplate.Overrides): boolean
function class:compare(filter)
	if not filter then
		return true
	end

	local fields = util.merge({ filter.definition or {}, filter.properties })

	local props = utils.TableCompareSubset(fields, self.element)
	local styles = utils.TableCompareSubset(filter.style, self.element.style --[[@as LuaStyle]])

	return props and styles
end

---@type fun(
---self: GuiTemplate.Context,
---template: GuiTemplate,
---filter: GuiTemplate.Overrides?)
---: GuiTemplate.Context[]
function class:getAllElements(template, filter)
	local root = self:getRoot()
	local matches = {}

	root:walk(function(ctx)
		if template.id ~= ctx.template.id then
			return
		end

		if not ctx:compare(filter) then
			return
		end

		table.insert(matches, ctx)
	end)

	return matches
end

---@type fun(
---self: GuiTemplate.Context,
---template: GuiTemplate,
---filter: GuiTemplate.Overrides?)
---: GuiTemplate.Context?
function class:getElement(template, filter)
	local matches = self:getAllElements(template, filter)
	return matches[1]
end

return class
