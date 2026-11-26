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

---Compares self.element with a subset of properties described in filter.
---If all fields in filter are present and equal to the corrisponding
---field in self.element this function will return true.
---@type fun(self: GuiTemplate.Context, filter: GuiTemplate.Filter.Fields): boolean
function class:compare(filter)
	if not filter then
		return true
	end

	local props = utils.TableCompareSubset(filter.properties, self.element)
	local styles = utils.TableCompareSubset(filter.style, self.element.style --[[@as LuaStyle]])

	return props and styles
end

---Returns a list of elements that match the template and filter.
---@type fun(
---self: GuiTemplate.Context,
---template: GuiTemplate,
---filter: GuiTemplate.Filter.Fields?)
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

---Returns the first element found that matches the template and filters.
---The order of elements is determined by their depth in the element tree,
---and if that is the same, it falls back to which one was created first.
---@type fun(
---self: GuiTemplate.Context,
---template: GuiTemplate,
---filter: GuiTemplate.Filter.Fields?)
---: GuiTemplate.Context?
function class:getElement(template, filter)
	local matches = self:getAllElements(template, filter)
	return matches[1]
end

return class
