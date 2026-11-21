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
	script.register_on_object_destroyed(entry.entity)
	storage.combinators[entry.entity.unit_number] = entry
end

---@param entry integer|Save.Combinators.Entry
M.remove = function(entry)
	local id = entry

	if type(id) ~= "number" then
		if not entry.entity.valid then
			error("Received non-valid entity")
		end

		id = entry.entity.unit_number
	end

	if not id then
		error("Received nil id, unable to remove entry")
	end

	storage.combinators[id] = nil
end

---@param entity LuaEntity
---@return Save.Combinators.Entry?
M.get = function(entity)
	return storage.combinators[entity.unit_number]
end

---@type fun(entity: LuaEntity): Save.Combinators.Entry
M.getOrCreate = function(entity)
	if not entity.valid then
		error("Received a non-valid entity")
	end

	local entry = M.get(entity)

	if not entry then
		entry = M.create(entity, utils.NewColor(0, 0, 0, 0))
		M.add(entry)
	end

	return entry
end

return M
