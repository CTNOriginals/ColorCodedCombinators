local const = require("shared.constants")
local utils = require("shared.utils")
local save = require("runtime.save.init")
local events = require("runtime.eventHandler")

local M = {}

---@type fun(entry: Save.Combinators.Entry)
M.clear = function(entry)
	if not entry.entity.valid then
		return
	end

	if entry.render and entry.render.valid then
		entry.render.destroy()
	end

	entry.render = nil
end

---@type fun(entry: Save.Combinators.Entry)
M.delete = function(entry)
	M.clear(entry)
	save.combinators.remove(entry)
end

---@type fun(entry: Save.Combinators.Entry)
M.draw = function(entry)
	if not entry.entity.valid then
		return
	end

	M.clear(entry)

	local name = utils.GetCombinatorEntityName(entry.type, { const.directionToName[entry.entity.direction] })
	local render = rendering.draw_sprite({
		sprite = name,
		target = entry.entity,
		surface = entry.entity.surface,
		render_layer = "object",
		tint = entry.color,
	})

	entry.render = render
end

---@type fun(entry: Save.Combinators.Entry, color: Color)
M.setColor = function(entry, color)
	if not entry.entity.valid then
		return
	end

	-- copy, so later changes to the passed table do not affect the stored color
	entry.color = utils.NewColor(color.r, color.g, color.b, color.a)

	M.draw(entry)
end

---@param event EventData.on_player_rotated_entity
local function onPlayerRotateEntity(event)
	local entry = save.combinators.get(event.entity)

	if not utils.GetCombinatorType(event.entity) or not entry then
		return
	end

	M.draw(entry)
end
events.register(defines.events.on_player_rotated_entity, onPlayerRotateEntity)

---@param event EventData.on_object_destroyed
local function onObjectDestroyed(event)
	if event.type ~= defines.target_type.entity then
		return
	end

	save.combinators.remove(event.useful_id)
end
events.register(defines.events.on_object_destroyed, onObjectDestroyed)

return M
