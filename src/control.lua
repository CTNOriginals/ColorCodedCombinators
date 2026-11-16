local utils = require("utils")
local overlay = require("overlay")
local storage = require("storage")

log("-- loaded --")

script.on_init(storage.init)
script.on_configuration_changed(storage.init)

script.on_event(defines.events.on_player_rotated_entity, function(event)
	if not utils.GetCombinatorType(event.entity) then
		return
	end
	overlay.draw(event.entity)
end)

script.on_event(defines.events.on_object_destroyed, function(event)
	if not event.type == defines.target_type.entity then
		return
	end
	storage.data.combinators[event.useful_id] = nil
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

	overlay.setColor(player.selected, color)
end)
