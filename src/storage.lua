---@class StorageCombinator
---@field type CombinatorType
---@field color Color
---@field render LuaRenderObject?

---@class LocalStorage
---@field combinators table<uint64, StorageCombinator>

---@type LocalStorage
local storage = storage

local function init()
	if not storage.combinators then
		storage.combinators = {}
	end
	log("Storage initialized: " .. serpent.block(storage))
end

return {
	init = init,
	data = storage,
}
