local utils = require("utils")

---@class Save.Player.ColorTool
---@field color Color
-- TODO: swatches

---@class Save.Player.Entry
---@field name string
---@field colorTool Save.Player.ColorTool

---@alias Save.Player.Map table<string, Save.Player.Entry>

local M = {}

M.init = function()
	if not storage.players then
		storage.players = {}
	end
end

---@param name string
---@return Save.Player.Entry
M.create = function(name)
	---@type Save.Player.Entry
	return {
		name = name,
		colorTool = {
			color = utils.NewColor(0, 0, 0, 0),
		},
	}
end

---@param entry Save.Player.Entry
M.add = function(entry)
	storage.players[entry.name] = entry
end

---@param name string
M.remove = function(name)
	storage.players[name] = nil
end

---@param name string
---@return Save.Player.Entry?
M.get = function(name)
	return storage.players[name]
end

return M
