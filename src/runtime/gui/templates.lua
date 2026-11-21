local const = require("shared.constants")
local util = require("util")
local M = {}

---@class GuiTemplate.Definition: LuaGuiElement.add_param.base
---@class (partial) GuiTemplate.Definition.Partial: GuiTemplate.Definition
---@class (partial) GuiTemplate.Style.Partial: LuaStyle

---@class GuiTemplate.Base
---@field properties GuiTemplate.Definition.Partial?
---@field style GuiTemplate.Style.Partial?

---@class GuiTemplate: GuiTemplate.Base
---@field definition GuiTemplate.Definition
M.class = {}

---@class GuiTemplate.Overrides: GuiTemplate.Base
---@field definition GuiTemplate.Definition.Partial?

M.class.__index = M.class
script.register_metatable(const.metatables.names.guiTemplate, M.class)

---@type fun(self: GuiTemplate, instance: GuiTemplate): GuiTemplate
function M.class:new(instance)
	instance = instance or {}
	return setmetatable(instance, self)
end

---@type fun(self: GuiTemplate, parent: LuaGuiElement, name: string?): string
function M.class:name(parent, name)
	local suffix = name or self.definition.name or self.definition.type
	return parent.name .. "_" .. suffix
end

---@type fun(
---self: GuiTemplate,
---parent: LuaGuiElement,
---overrides: GuiTemplate.Overrides?)
---: LuaGuiElement
function M.class:build(parent, overrides)
	local template = util.merge({ self, overrides or {} })
	local element = parent.add(template.definition)

	element.name = self:name(parent, template.definition.name)
	log(element.name)

	for key, value in pairs(template.properties or {}) do
		element[key] = value
	end

	for key, value in pairs(template.style or {}) do
		element.style[key] = value
	end

	return element
end

return M
