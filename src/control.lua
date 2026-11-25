local utils = require("shared.utils")
local overlay = require("runtime.overlay")
local const = require("shared.constants")
local save = require("runtime.save.init")
local gui = require("runtime.gui.init")
local events = require("runtime.eventHandler")
require("runtime.dev")

script.on_init(save.init)
script.on_configuration_changed(save.init)

script.on_load(function()
	-- save.log()
end)

script.on_nth_tick(10, function()
	script.on_nth_tick(10, nil)
	local player = save.players.get("CTN")
	if not player then
		return
	end
	gui.ui.colorTool.open(player)
end)

---@param event EventData.on_player_selected_area | EventData.on_player_alt_selected_area
local function onToolSelected(event)
	if event.item ~= const.shortcut.tool then
		return
	end

	local playerEntry = save.players.getOrCreate(event.player_index)

	if #event.entities == 0 then
		gui.ui.colorTool.open(playerEntry)
		playerEntry.player.clear_cursor()
		return
	end

	local color = playerEntry.colorTool.color

	for _, entity in pairs(event.entities) do
		local combEntry = save.combinators.get(entity)

		if event.name == defines.events.on_player_alt_selected_area then
			if combEntry then
				overlay.delete(combEntry)
			end
		else
			if not combEntry then
				combEntry = save.combinators.create(entity, color)
				save.combinators.add(combEntry)
			end

			overlay.setColor(combEntry, color)
		end
	end
end

events.register(defines.events.on_player_selected_area, onToolSelected)
events.register(defines.events.on_player_alt_selected_area, onToolSelected)
