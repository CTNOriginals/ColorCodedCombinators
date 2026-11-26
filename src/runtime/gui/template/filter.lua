---@class GuiTemplate.Filter.Fields: GuiTemplate.Base
---@field template? GuiTemplate|GuiTemplate.Fields
---@field parent? GuiTemplate.Filter

---@class GuiTemplate.Filter: GuiTemplate.Filter.Fields
---@field template GuiTemplate.Fields
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

return class
