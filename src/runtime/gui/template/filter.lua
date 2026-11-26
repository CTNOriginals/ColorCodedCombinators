---@class GuiTemplate.Filter.Fields: GuiTemplate.Base
---@field parent GuiTemplate.Filter?

---@class GuiTemplate.Filter: GuiTemplate.Filter.Fields
local class = {}
---@private
class.__index = class

---@type fun(fields: GuiTemplate.Filter.Fields): GuiTemplate.Filter
function class.new(fields)
	local instance = fields --[[@as GuiTemplate.Filter]]
	return setmetatable(instance, class)
end

return class
