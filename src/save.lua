---@class StorageCombinator
---@field type CombinatorType
---@field color Color
---@field render LuaRenderObject?

---@alias StorageCombinatorMap table<uint64, StorageCombinator>

---@class SaveStorage
---@field combinators StorageCombinatorMap

local M = {}

---@type SaveStorage
M.storage = storage

M.init = function()
	if not M.storage.combinators then
		M.storage.combinators = {}
	end
	log("Storage initialized: " .. serpent.block(M.storage))
end

return M
