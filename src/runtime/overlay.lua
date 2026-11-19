local const = require("shared.constants")
local utils = require("shared.utils")
local save = require("runtime.save.init")

local M = {}

---@param entity LuaEntity the combinator
M.clear = function(entity)
	local entry = save.combinators.get(entity)
	if not entry then
		return
	end

	if entry.render and entry.render.valid then
		entry.render.destroy()
	end

	entry.render = nil
end

---@param entity LuaEntity the combinator
M.draw = function(entity)
	local entry = save.combinators.get(entity)

	if not entry then
		return
	end

	M.clear(entity)

	local name = utils.GetCombinatorEntityName(entry.type, { const.directionToName[entity.direction] })
	local render = rendering.draw_sprite({
		sprite = name,
		target = entity,
		surface = entity.surface,
		render_layer = "object",
		tint = entry.color,
	})

	entry.render = render
end

---@param entity LuaEntity the combinator
---@param color Color e.g. {r = 1, g = 0, b = 0}
M.setColor = function(entity, color)
	if not entity or not entity.valid or not utils.GetCombinatorType(entity) then
		return
	end

	-- copy, so later changes to the passed table do not affect the stored color
	color = utils.NewColor(color.r, color.g, color.b, color.a)

	local entry = save.combinators.get(entity)

	if entry then
		entry.color = color
	else
		entry = save.combinators.create(entity, color)
		save.combinators.add(entry)
		script.register_on_object_destroyed(entity)
	end

	M.draw(entity)
end

return M
