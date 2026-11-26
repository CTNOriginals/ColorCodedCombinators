local registry = require("runtime.gui.registry")
---@class GuiTemplate.Filter.Fields: GuiTemplate.Base
---@field template? GuiTemplate|GuiTemplate.Fields
---@field parent? GuiTemplate.Filter

---@class GuiTemplate.Filter: GuiTemplate.Filter.Fields
---@field template? GuiTemplate.Fields
local class = {}
---@private
class.__index = class

---@type fun(fields: GuiTemplate.Filter.Fields): GuiTemplate.Filter
function class.new(fields)
	local instance = fields or {}

	--If template is a full template ref,
	--reduce the fields to id and type,
	--no more is needed to force an exact match.
	if fields.template and fields.template["id"] then
		---@type GuiTemplate.Fields
		instance.template = {
			id = fields.template.id,
			definition = {
				type = fields.template.definition.type,
			},
		}
	end

	return setmetatable(instance --[[@as GuiTemplate.Filter]], class)
end

---@type fun(self: GuiTemplate.Filter, element: LuaGuiElement): boolean
function class:compareElement(element)
	self.parent:compareElement(element.parent)

	return true
end

---@type fun(self: GuiTemplate.Filter, context: GuiTemplate.Context): boolean
function class:compare(ctx)
	---@type [table, table][]
	local compairs = {
		{ self.template, ctx.template },
	}

	if ctx.element.parent then
		local parentTemplate = registry.getTemplate(ctx.element.parent)
		if not self.parent:compare(parentTemplate:context(ctx.element.parent)) then
			return false
		end
	elseif self.parent then
		return false
	end

	return true
end

return class
