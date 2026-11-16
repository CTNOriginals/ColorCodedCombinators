local utils = require("utils")

---@class StorageCombinator
---@field type CombinatorType
---@field entity LuaEntity
---@field color Color
---@field render LuaRenderObject?

---@alias StorageCombinatorMap table<uint64, StorageCombinator>

---@class SaveStorage
---@field combinators StorageCombinatorMap

local M = {}

---@type SaveStorage

M.init = function()
	if not storage.combinators then
		storage.combinators = {}
	end
	log("Storage initialized: " .. serpent.block(storage))
end

---@param entity LuaEntity
---@param color Color
---@return StorageCombinator
M.createEntry = function(entity, color)
	return {
		entity = entity,
		type = utils.GetCombinatorType(entity),
		color = color,
	}
end

---@param entry StorageCombinator
M.addEntry = function(entry)
	storage.combinators[entry.entity.unit_number] = entry
end

---@param id integer
M.removeEntry = function(id)
	storage.combinators[id] = nil
end

---@param entity LuaEntity
---@return StorageCombinator?
M.getEntry = function(entity)
	if not storage.combinators then
		log("[WARN] storage.combinators is nil. Re-initializing storage.")
		M.init()
	end

	return storage.combinators[entity.unit_number]
end

return M
