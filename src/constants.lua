---@alias CombinatorNameString 'decider' | 'arithmetic' | 'constant' | 'selector'

---@class Combinators<T>: {[CombinatorNameString]: T}
---@field decider T
---@field arithmetic T
---@field selector T
---@field constant T

local M = {
	entity = {
		prefix = "ccc-",
		---@type Combinators<string>
		combinator = {
			decider = "decider-combinator",
			arithmetic = "arithmetic-combinator",
			selector = "selector-combinator",
			constant = "constant-combinator",
		},
		---@type CombinatorNameString[]
		combinatorNames = { "decider", "arithmetic", "constant", "selector" },
	},
	sprite = {
		directions = {
			[defines.direction.north] = "north",
			[defines.direction.east] = "east",
			[defines.direction.south] = "south",
			[defines.direction.west] = "west",
		},
		directionsNames = { "north", "east", "south", "west" },
	},
}

return M
