local const = require("constants")
local utils = require("utils")
local save = require("save")

local M = {}

---@param entity LuaEntity the decider combinator
M.clear = function(entity)
	---@type StorageCombinator?
	local entry = save.getEntry(entity)
	if not entry then
		return
	end

	if entry.render and entry.render.valid then
		entry.render.destroy()
	end

	entry.render = nil
end

---@param entity LuaEntity the decider combinator
M.draw = function(entity)
	---@type StorageCombinator?
	local entry = save.getEntry(entity)
	local combType = utils.GetCombinatorType(entity)
	if not entry or not combType then
		return
	end

	M.clear(entity)

	local name = utils.GetCombinatorEntityName(combType, { const.sprite.directions[entity.direction] })
	local render = rendering.draw_sprite({
		sprite = name,
		target = entity,
		surface = entity.surface,
		render_layer = "object",
		tint = entry.color,
	})

	entry.render = render
	log("drew entry " .. combType .. "(" .. entry.entity.unit_number .. "): " .. serpent.line(entry.color))
end

---@param entity LuaEntity the decider combinator
---@param color Color e.g. {r = 1, g = 0, b = 0}
M.setColor = function(entity, color)
	local combType = utils.GetCombinatorType(entity)
	if not entity or not entity.valid or not combType then
		return
	end

	---@type StorageCombinator?
	local entry = save.getEntry(entity)

	if entry then
		entry.color = color
	else
		entry = save.createEntry(entity, color)
		save.addEntry(entry)
	end

	script.register_on_object_destroyed(entity)
	M.draw(entity)
end

return M
