---@class Save
---@field combinators Save.Combinators.Map
---@field players Save.Player.Map

---@type Save
storage = storage

local M = {
	combinators = require("runtime.save.combinators"),
	players = require("runtime.save.player"),
}

M.init = function()
	for _, mod in pairs(M) do
		if type(mod) == "table" and mod.init then
			mod.init()
		end
	end
	log("Storage initialized: " .. serpent.line(storage, { sparse = true }))
end

return M
