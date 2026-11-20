local const = require("shared.constants")
local M = {}

---@class M.TTemplate
local templateClass = {
	---@type LuaGuiElement.add_param
	definition = {
		type = "empty-widget",
	},

	style = {}, --[[@as LuaStyle]]
}

M.metatable = setmetatable(templateClass, {
	__index = templateClass,
})

script.register_metatable(const.metatables.names.guiTemplate, M.metatable)

---@type fun(self: M.TTemplate, instance: M.TTemplate): M.TTemplate
function templateClass:new(instance)
	instance = self
	return instance
end

---@type fun(self: M.TTemplate, parent: LuaGuiElement): LuaGuiElement
function templateClass:build(parent)
	local element = parent.add(self.definition)

	for style, value in pairs(self.style) do
		element.style[style] = value
	end

	return element
end

return M
