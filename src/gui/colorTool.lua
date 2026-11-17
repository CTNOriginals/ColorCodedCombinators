local const = require("constants")
local utils = require("utils")

local M = {}

---@alias onGuiEvents defines.events.on_gui_value_changed
---| defines.events.on_gui_text_changed

---@type table<string, fun(event: onGuiEvents)>
M.handlers = {}

---@param element LuaGuiElement
---@param fn fun(element: LuaGuiElement, depth: integer)
---@param dir 'down'|'up'
---@param depth integer?
local function recurse(element, fn, dir, depth)
	if not depth then
		depth = 0
	end

	if not element then
		return
	end

	fn(element, depth)

	local next = element.children
	if dir == "up" then
		next = { element.parent }
	end

	for _, child in pairs(next) do
		recurse(child, fn, dir, depth + 1)
	end
end

---@param entry Save.Player.Entry
---@param parent LuaGuiElement?
---@return string
M.getName = function(entry, parent, ...)
	local name = const.gui.colorTool .. entry.player.name
	local trail = { ... }

	if parent then
		name = parent.name
	end

	if not trail or #trail == 0 then
		return name
	end

	return name .. "-" .. table.concat(trail, "-")
end

---@param entry Save.Player.Entry
M.open = function(entry)
	if not entry.player.valid then
		return
	end

	local existing = entry.player.gui.screen[M.getName(entry)]
	if existing then
		existing.destroy()
	end

	local frame = entry.player.gui.screen.add({
		type = "frame",
		name = M.getName(entry),
		caption = { "gui.color-tool-title" },
		direction = "vertical",
	})
	frame.auto_center = true

	local section = frame.add({
		type = "frame",
		name = M.getName(entry, frame, "section"),
		direction = "vertical",
	})

	local color = section.add({
		type = "progressbar",
		name = M.getName(entry, section, "sprite"),
	})

	color.value = 1
	color.style.bar_width = 25
	color.style.vertically_stretchable = true
	color.style.horizontally_stretchable = true

	color.style.vertical_align = "center"
	color.style.horizontal_align = "center"
	color.style.width = 208
	color.style.height = 20

	color.style.color = entry.colorTool.color

	for name, val in pairs(entry.colorTool.color) do
		local row = section.add({
			type = "flow",
			name = M.getName(entry, section, name, "row"),
			direction = "horizontal",
		})

		local label = row.add({
			type = "label",
			name = M.getName(entry, row, "label"),
			caption = string.upper(name),
		})
		local slider = row.add({
			type = "slider",
			name = M.getName(entry, row, "slider"),
			minimum_value = 0,
			maximum_value = 1,
			value_step = 0.01,
		})
		local value = row.add({
			type = "textfield",
			name = M.getName(entry, row, "value"),
			numeric = true,
			text = tostring(val),
		})

		local total = 200
		local ratios = {
			label = 0.1,
			slider = 0.7,
			value = 0.2,
		}

		row.style.vertical_align = "center"

		-- label.style.font_color = utils.NewColor(0, 1, 0, 1)
		label.style.width = total * ratios.label
		label.style.horizontal_align = "center"
		label.style.vertical_align = "center"

		slider.style.width = total * ratios.slider
		slider.style.top_margin = 2
		slider.style.vertical_align = "center"
		slider.style.horizontal_align = "center"

		value.style.width = total * ratios.value
		value.style.height = 20
	end

	recurse(frame, function(element, depth)
		log(element.name)
	end, "down")
end

return M
