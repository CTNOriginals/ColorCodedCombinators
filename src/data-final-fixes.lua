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
---@param def Sprite the layer returned by get_main_layer
---@return SpritePrototype
local function make_sprite_prototype(name, def)
	---@type SpritePrototype
	local proto = {
		type = "sprite",
		name = name,
		layers = { def },
	}

	return proto
end

local decider = data.raw[const.entity.combinator.decider][const.entity.combinator.decider]
local new_prototypes = {}

for _, dir in pairs(const.sprite.directions) do
	local layer = get_main_layer(decider.sprites[dir])
	local proto = make_sprite_prototype(const.entity.prefix .. dir, layer)
	table.insert(new_prototypes, proto)
end

data:extend(new_prototypes)
log(serpent.block(new_prototypes))
