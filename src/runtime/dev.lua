-- Dev only: lets `make reload` trigger a reload of the mod scripts from outside the game.
-- Requires factorio to be started with --enable-lua-udp (see FACTORIO_ARGS in the Makefile).
-- TODO: do not ship this in a release

local const = require("shared.constants")
local events = require("runtime.eventHandler")

local RELOAD_PAYLOAD = const.reloadPayload

-- received packets only turn into events once recv_udp is called
script.on_nth_tick(30, function()
	helpers.recv_udp()
end)

---@param event EventData.on_udp_packet_received
local function onUdpPacketReceived(event)
	if event.payload ~= RELOAD_PAYLOAD then
		return
	end

	log("---- dev: reloading mods ----\n")
	game.reload_mods()
end
events.register(defines.events.on_udp_packet_received, onUdpPacketReceived)
