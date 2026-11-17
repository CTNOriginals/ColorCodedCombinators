---@alias CombinatorType 'decider' | 'arithmetic' | 'constant' | 'selector'

---@class Combinators<T>: {[CombinatorType]: T}
---@field decider T
---@field arithmetic T
---@field selector T
---@field constant T

local prefix = "ccc-"

local M = {
	---@type CombinatorType[]
	combinatorTypes = { "decider", "arithmetic", "constant", "selector" },
	entity = {
		prefix = prefix,
		---@type Combinators<string>
		combinators = {
			decider = "decider-combinator",
			arithmetic = "arithmetic-combinator",
			selector = "selector-combinator",
			constant = "constant-combinator",
		},
	},
	shortcut = {
		name = prefix .. "color-tool",
		tool = prefix .. "color-tool",
		input = prefix .. "color-tool-input",
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
