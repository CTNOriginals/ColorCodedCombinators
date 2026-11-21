local utils = require("shared.utils")

---@class Save.Combinators.Entry
---@field type CombinatorType
---@field entity LuaEntity
---@field color Color
---@field render LuaRenderObject?

---@alias Save.Combinators.Map table<uint64, Save.Combinators.Entry>

local M = {}

M.log = function()
	for id, entry in pairs(storage.combinators) do
		log(id .. ": " .. serpent.line(entry.color) .. " - " .. entry.type)
	end
end

M.init = function()
	if not storage.combinators then
		storage.combinators = {}
	end
end

---@param entity LuaEntity
---@param color Color
---@return Save.Combinators.Entry
M.create = function(entity, color)
	return {
		entity = entity,
		type = utils.GetCombinatorType(entity),
		color = color,
	}
end

---@param entry Save.Combinators.Entry
M.add = function(entry)
	storage.combinators[entry.entity.unit_number] = entry
end

---@param id integer
M.remove = function(id)
	storage.combinators[id] = nil
end

---@param entity LuaEntity
---@return Save.Combinators.Entry?
M.get = function(entity)
	return storage.combinators[entity.unit_number]
end

return M
