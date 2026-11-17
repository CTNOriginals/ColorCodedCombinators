---@class Save
---@field combinators Save.Combinators
local M = {
	combinators = require("save.combinators"),
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
