local const = require("shared.constants")
local util = require("util")
local context = require("runtime.gui.template.context")

---@class GuiTemplate.Definition: LuaGuiElement.add_param.base
---@class (partial) GuiTemplate.Definition.Partial: GuiTemplate.Definition
---@class (partial) GuiTemplate.Style.Partial: LuaStyle

---@alias GuiTemplate.Events.Callback<T> fun(event: T, ctx: GuiTemplate.Context)

---@class GuiTemplate.Events
---@field on_gui_click GuiTemplate.Events.Callback<EventData.on_gui_click>?
---@field on_gui_value_changed GuiTemplate.Events.Callback<EventData.on_gui_value_changed>?
---@field on_gui_text_changed GuiTemplate.Events.Callback<EventData.on_gui_text_changed>?

---@class GuiTemplate.Base
---@field properties GuiTemplate.Definition.Partial?
---@field style GuiTemplate.Style.Partial?
---@field events GuiTemplate.Events?

---@class GuiTemplate.Fields: GuiTemplate.Base
---@field id string?
---@field definition GuiTemplate.Definition

---@class GuiTemplate.Overrides: GuiTemplate.Base
---@field definition GuiTemplate.Definition.Partial?

---@class GuiTemplate: GuiTemplate.Fields
local class = {}
class.__index = class

---@type fun(fields: GuiTemplate.Fields): GuiTemplate
function class.new(fields)
	local instance = fields --[[@as GuiTemplate]]
	return setmetatable(instance, class)
end

---@type fun(self: GuiTemplate, parent: LuaGuiElement, name: string?): string
function class:name(parent, name)
	local suffix = name or self.definition.name or self.definition.type
	return parent.name .. "_" .. suffix
end

---@type fun(
---self: GuiTemplate,
---parent: LuaGuiElement,
---overrides: GuiTemplate.Overrides?)
---: LuaGuiElement
function class:build(parent, overrides)
	local id = self.id

	if not id then
		error("[WARNING] Unknown Gui Template: " .. serpent.line(self, { sparse = true }))
	end

	self.id = id

	local template = util.merge({ self, overrides or {} })

	template.definition.tags = template.definition.tags or {}
	template.definition.tags["template"] = self.id

	local element = parent.add(template.definition)

	element.name = self:name(parent, template.definition.name)
	-- log(element.name)

	for key, value in pairs(template.properties or {}) do
		element[key] = value
	end

	for key, value in pairs(template.style or {}) do
		element.style[key] = value
	end

	return element
end

---@type fun(self: GuiTemplate, element: LuaGuiElement): GuiTemplate.Context
function class:context(element)
	return context.new({
		element = element,
		template = self,
	})
end

return class
