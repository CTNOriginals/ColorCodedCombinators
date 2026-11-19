local utils = require("shared.utils")
local overlay = require("runtime.overlay")
local const = require("shared.constants")
local save = require("runtime.save.init")
local gui = require("runtime.gui.init")
require("runtime.dev")

log("-- loaded --")

script.on_init(save.init)
script.on_configuration_changed(save.init)

script.on_load(function()
	-- log("Storage(" .. table_size(storage.combinators) .. "): " .. serpent.line(storage, {
	-- 	sparse = true,
	-- 	refcomment = true,
	-- }))
end)
-- script.on_nth_tick(10, function()
-- 	script.on_nth_tick(10, nil)
--
-- 	local player = game.get_player(1)
-- 	if not player then
-- 		log("no player")
-- 		return
-- 	end
--
-- 	gui.colorTool.open(save.players.getOrCreate(player.name))
-- end)

script.on_event(defines.events.on_player_rotated_entity, function(event)
	if not utils.GetCombinatorType(event.entity) or not save.combinators.get(event.entity) then
		return
	end

	overlay.draw(event.entity)
end)

script.on_event(defines.events.on_object_destroyed, function(event)
	if not event.type == defines.target_type.entity then
		return
	end
	save.combinators.remove(event.useful_id)
end)

---@param event EventData.on_player_selected_area | EventData.on_player_alt_selected_area
local function onToolSelected(event)
	if event.item ~= const.shortcut.tool then
		return
	end

	local entry = save.players.getOrCreate(event.player_index)

	if #event.entities == 0 then
		gui.colorTool.open(entry)
		entry.player.clear_cursor()
		return
	end

	local color = entry.colorTool.color

	for _, entity in pairs(event.entities) do
		if event.name == defines.events.on_player_alt_selected_area then
			overlay.clear(entity)
		else
			overlay.setColor(entity, color)
		end
	end
end

script.on_event(defines.events.on_player_selected_area, onToolSelected)
script.on_event(defines.events.on_player_alt_selected_area, onToolSelected)
