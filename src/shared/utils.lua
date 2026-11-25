local const = require("shared.constants")

local M = {}

---Returns the full name string including the prefix
---@param type CombinatorType
---@param trail string[]?
---@return string
M.GetCombinatorEntityName = function(type, trail)
	local start = const.prefix .. const.combinatorEntities[type]

	if trail and #trail > 0 then
		return start .. "-" .. table.concat(trail, "-")
	end

	return start
end

---@param entity LuaEntity
---@return CombinatorType?
M.GetCombinatorType = function(entity)
	for type, name in pairs(const.combinatorEntities) do
		if entity.name == name then
			return type
		end
	end

	return nil
end

---@param r float
---@param g float
---@param b float
---@param a float
---@return Color
M.NewColor = function(r, g, b, a)
	return {
		r = r,
		g = g,
		b = b,
		a = a,
	}
end

-- M.TableComparePresent()
---@type fun(subset: table, target: table): boolean
function M.TableCompareSubset(subset, target)
	if not subset then
		return true
	elseif not target then
		return false
	end

	for key in pairs(subset) do
		if target[key] == nil then
			return false
		end

		if type(subset[key]) == "table" then
			if not M.TableCompareSubset(subset[key], target[key]) then
				return false
			end
		else
			if subset[key] ~= target[key] then
				return false
			end
		end
	end

	return true
end

return M
