local utils = require("utils")

---@class Save.Player.ColorTool
---@field color Color
-- TODO: swatches

---@class Save.Player.Entry
---@field player LuaPlayer
---@field colorTool Save.Player.ColorTool

---@alias Save.Player.Map table<string, Save.Player.Entry>

local M = {}

local function getPlayerName(playerId)
	if type(playerId) == "string" then
		return playerId
	end

	local player = game.get_player(playerId)

	if not player then
		return ""
	end

	return player.name
end

M.init = function()
	if not storage.players then
		storage.players = {}
	end
end

---@param playerId string|integer The players name or index
---@return Save.Player.Entry?
M.create = function(playerId)
	local player = game.get_player(playerId)

	if not player then
		return nil
	end

	---@type Save.Player.Entry
	return {
		player = player,
		colorTool = {
			color = utils.NewColor(0, 0, 0, 0),
		},
	}
end

---@param entry Save.Player.Entry
M.add = function(entry)
	storage.players[entry.player.name] = entry
end

---@param playerId string|integer
M.remove = function(playerId)
	storage.players[getPlayerName(playerId)] = nil
end

---@param playerId string|integer
---@return Save.Player.Entry?
M.get = function(playerId)
	return storage.players[getPlayerName(playerId)]
end

return M
