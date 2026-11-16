local storage = require("storage")
local const = require("constants")

log("-- loaded --")

script.on_init(storage.init)
script.on_configuration_changed(storage.init)

---@param entity LuaEntity
---@return boolean
local function isCombinator(entity)
	for _, name in pairs(const.entity.combinator) do
		if name == entity.name then
			return true
		end
	end

	return false
end

---@param entity LuaEntity the decider combinator
local function clear_overlay(entity)
	---@type StorageCombinator?
	local entry = storage.combinators[entity.unit_number]
	if not entry then
		return
	end

	if entry.render and entry.render.valid then
		entry.render.destroy()
	end

	entry.render = nil
end

---@param entity LuaEntity the decider combinator
local function draw_overlay(entity)
	---@type StorageCombinator?
	local entry = storage.combinators[entity.unit_number]
	if not entry then
		return
	end

	clear_overlay(entity)

	local name = const.entity.prefix .. const.sprite.directions[entity.direction]
	local render = rendering.draw_sprite({
		sprite = name,
		target = entity,
		surface = entity.surface,
		render_layer = "object",
		tint = entry.color,
	})

	entry.render = render
end

---@param entity LuaEntity the decider combinator
---@param color Color e.g. {r = 1, g = 0, b = 0}
local function set_color(entity, color)
	if not entity or not entity.valid or not isCombinator(entity) then
		return
	end

	---@type StorageCombinator?
	local entry = storage.combinators[entity.unit_number]

	if entry then
		entry.color = color
	else
		entry = { color = color }
		storage.combinators[entity.unit_number] = entry
	end

	script.register_on_object_destroyed(entity)
	draw_overlay(entity)
end

script.on_event(defines.events.on_player_rotated_entity, function(event)
	if not isCombinator(event.entity) then
		return
	end
	draw_overlay(event.entity)
end)

script.on_event(defines.events.on_object_destroyed, function(event)
	if not event.type == defines.target_type.entity then
		return
	end
	storage.combinators[event.useful_id] = nil
end)

---@type table<string, Color>
local COLORS = {
	none = { r = 0, g = 0, b = 0 },
	red = { r = 1, g = 0, b = 0 },
	green = { r = 0, g = 1, b = 0 },
	blue = { r = 0, g = 0, b = 1 },
}

commands.add_command("proto-color", "Color the hovered decider", function(cmd)
	if not cmd.player_index then
		return
	end
	local player = game.get_player(cmd.player_index)
	if not player or not player.selected then
		return
	end
	local color = COLORS.none
	if cmd.parameter then
		color = COLORS[cmd.parameter]
	end

	set_color(player.selected, color)
end)
