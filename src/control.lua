local utils = require("utils")
local overlay = require("overlay")
local const = require("constants")
local save = require("save")
local gui = require("gui.init")
require("dev")

log("-- loaded --")

script.on_init(save.init)
script.on_configuration_changed(save.init)

script.on_load(function()
	log("Storage(" .. table_size(storage.combinators) .. "): " .. serpent.block(storage, {
		sparse = true,
		refcomment = true,
	}))
end)
script.on_nth_tick(10, function()
	script.on_nth_tick(10, nil)

	local player = game.get_player(1)
	if not player then
		log("no player")
		return
	end

	gui.open(player)
end)

script.on_event(defines.events.on_player_rotated_entity, function(event)
	if not utils.GetCombinatorType(event.entity) or not save.getEntry(event.entity) then
		return
	end

	overlay.draw(event.entity)
end)

script.on_event(defines.events.on_object_destroyed, function(event)
	if not event.type == defines.target_type.entity then
		return
	end
	save.removeEntry(event.useful_id)
end)

local alpha = 0.4
---@type table<string, Color>
local COLORS = {
	none = { r = 0, g = 0, b = 0, a = 0 },
	red = { r = 1, g = 0, b = 0, a = alpha },
	green = { r = 0, g = 1, b = 0, a = alpha },
	blue = { r = 0, g = 0, b = 1, a = alpha },
}

---@param event EventData.on_player_selected_area | EventData.on_player_alt_selected_area
local function onToolSelected(event)
	if event.item ~= const.shortcut.tool then
		return
	end

	if #event.entities == 0 then
		local player = game.get_player(event.player_index)
		if not player then
			return
		end
		gui.open(player)
		player.clear_cursor()
		return
	end

	for _, entity in pairs(event.entities) do
		overlay.setColor(entity, gui.color)
	end
end

-- TODO: placeholder colors until the tool has a way to pick one
script.on_event(defines.events.on_player_selected_area, onToolSelected)
script.on_event(defines.events.on_player_alt_selected_area, onToolSelected)

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
