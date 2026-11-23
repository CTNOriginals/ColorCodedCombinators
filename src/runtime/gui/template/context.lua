local save = require("runtime.save.init")

---@class GuiTemplate.Context.Fields
---@field element LuaGuiElement
---@field template GuiTemplate

---@class GuiTemplate.Context: GuiTemplate.Context.Fields
local class = {}
class.__index = class

---@type fun(self: GuiTemplate.Context, fields: GuiTemplate.Context.Fields): GuiTemplate.Context
function class:new(fields)
	local instance = fields --[[@as GuiTemplate.Context]]
	return setmetatable(instance, self)
end

---@type fun(self: GuiTemplate.Context): Save.Player.Entry
function class:playerEntry()
	local index = self.element.player_index
	local player = save.players.get(index)

	if not player then
		error("Unable to get player entry by index: " .. index)
	end

	return player
end

---@type fun(
---self: GuiTemplate.Context,
---template: GuiTemplate,
---filter: GuiTemplate.Overrides)
---: GuiTemplate.Context?
function class:getElement(template, filter)
	return nil
end

return class
