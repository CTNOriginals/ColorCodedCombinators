local combinators = require("runtime.save.combinators")
local players = require("runtime.save.player")

---@class Save
---@field combinators Save.Combinators.Map
---@field players Save.Player.Map

---@type Save
storage = storage

local M = {
	combinators = combinators,
	players = players,
}

M.log = function()
	M.combinators.log()
	M.players.log()
end

M.init = function()
	for _, mod in pairs(M) do
		if type(mod) == "table" and mod.init then
			mod.init()
		end
	end
	M.log()
end

return M
