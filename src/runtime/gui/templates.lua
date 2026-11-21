local const = require("shared.constants")
local M = {}

---@class GuiTemplate
local templateClass = {
	definition = {}, --[[@as LuaGuiElement.add_param]]
	style = {}, --[[@as LuaStyle]]
}

templateClass.__index = templateClass
script.register_metatable(const.metatables.names.guiTemplate, templateClass)

M.class = templateClass

---@type fun(self: GuiTemplate, instance: GuiTemplate): GuiTemplate
function templateClass:new(instance)
	instance = instance or {}
	return setmetatable(instance, self)
end

---@type fun(self: GuiTemplate, parent: LuaGuiElement): LuaGuiElement
function templateClass:build(parent)
	local element = parent.add(self.definition)
	element.name = parent.name .. "-" .. element.type

	for style, value in pairs(self.style) do
		element.style[style] = value
	end

	return element
end

return M
