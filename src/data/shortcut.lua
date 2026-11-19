local const = require("shared.constants")

---@type string[]
local combinatorNames = {}
for _, name in pairs(const.combinatorEntities) do
	table.insert(combinatorNames, name)
end

---@param color Color
---@return SelectionModeData
local function make_select_mode(color)
	return {
		border_color = color,
		cursor_box_type = "entity",
		mode = { "buildable-type", "same-force" },
		entity_filters = combinatorNames,
	}
end

-- TODO: replace the placeholder base game icons with custom sprites
data:extend({
	{
		type = "selection-tool",
		name = const.shortcut.tool,
		icon = "__base__/graphics/icons/blueprint.png",
		flags = { "only-in-cursor", "spawnable", "not-stackable" },
		hidden = true,
		stack_size = 1,
		select = make_select_mode({ r = 0, g = 1, b = 0 }),
		alt_select = make_select_mode({ r = 1, g = 0, b = 0 }),
	},
	{
		type = "custom-input",
		name = const.shortcut.input,
		key_sequence = "C",
		action = "spawn-item",
		item_to_spawn = const.shortcut.tool,
	},
	{
		type = "shortcut",
		name = const.shortcut.name,
		action = "spawn-item",
		associated_control_input = const.shortcut.input,
		item_to_spawn = const.shortcut.tool,
		icon = "__base__/graphics/icons/shortcut-toolbar/mip/new-blueprint-x56.png",
		icon_size = 56,
		small_icon = "__base__/graphics/icons/shortcut-toolbar/mip/new-blueprint-x24.png",
		small_icon_size = 24,
	},
})
