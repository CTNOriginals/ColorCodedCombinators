---@class GuiTemplate.Context
---@field entry Save.Player.Entry
---@field template GuiTemplate
---@field tags Tags
local class = {}
class.__index = class

---@type fun(self: GuiTemplate.Context, instance: GuiTemplate.Context): GuiTemplate.Context
function class:new(instance)
	instance = instance or {}
	return setmetatable(instance, self)
end

---@type fun(self: GuiTemplate.Context, template: GuiTemplate, match: GuiTemplate.Overrides): GuiTemplate.Context?
function class:getReference(template, match)
	return nil
end

return class
