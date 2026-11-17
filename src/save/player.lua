local utils = require("utils")

---@class Save.Player.ColorTool
---@field color Color
-- TODO: swatches

---@class Save.Player.Entry
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
		colorTool = {
			color = utils.NewColor(0, 0, 0, 0),
		},
	}
end

return M
