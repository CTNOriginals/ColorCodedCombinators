local const = require("constants")

local M = {}

---Returns the full name string including the prefix
---@param type CombinatorType
---@param trail string[]?
---@return string
M.GetCombinatorEntityName = function(type, trail)
	local start = const.entity.prefix .. const.entity.combinators[type]

	if trail and #trail > 0 then
		return start .. "-" .. table.concat(trail, "-")
	end

	return start
end

---@param entity LuaEntity
---@return string?
M.GetCombinatorType = function(entity)
	for type, name in pairs(const.entity.combinators) do
		if entity.name == name then
			return type
		end
	end

	return nil
end

return M
