require("utils")

local const = require("constants")

---@param sprite Sprite one direction of the decider's Sprite4Way (e.g. decider.sprites.north)
---@return Sprite main_layer copy of the non-shadow layer
local function get_main_layer(sprite)
	local copy = table.deepcopy(sprite)

	if copy["layers"] ~= nil then
		for _, layer in pairs(copy.layers) do
			if not layer.draw_as_shadow then
				return layer
			end
		end
	end

	return copy
end

---@param name string unique sprite name, e.g. "proto-decider-north"
---@param layers Sprite the layer returned by get_main_layer
---@return SpritePrototype
local function make_sprite_prototype(name, layers)
	---@type SpritePrototype
	local proto = {
		type = "sprite",
		name = name,
		layers = { layers },
	}

	return proto
end

local newPrototypes = {}

for _, combType in pairs(const.combinatorTypes) do
	local entityName = const.entity.combinators[combType]
	local def = data.raw[entityName][entityName]

	for _, dir in pairs(const.sprite.directionsNames) do
		local layer = get_main_layer(def.sprites[dir])
		local protoName = GetCombinatorEntityName(combType, { dir })
		local proto = make_sprite_prototype(protoName, layer)
		table.insert(newPrototypes, proto)
		log(protoName)
	end
end

data:extend(newPrototypes)
