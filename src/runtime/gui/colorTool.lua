local const = require("shared.constants")
local template = require("runtime.gui.templates")

local M = {}

---@type table<string, GuiTemplate>
M.templates = {
	section = template.class:new({
		---@type LuaGuiElement.add_param.frame
		definition = {
			type = "frame",
			direction = "vertical",
		},
		style = {},
	}),
}

---@type table<string, fun(event: OnGuiEvents)>
M.handlers = {}

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

	-- local section = frame.add({
	-- 	type = "frame",
	-- 	name = M.getName(entry, frame, "section"),
	-- 	direction = "vertical",
	-- })
	-- local section =

	local section = M.templates.section:build(frame)
	local preview = section.add({
		type = "progressbar",
		name = M.getName(entry, section, "sprite"),
	})

	preview.value = 1
	preview.style.bar_width = 25
	preview.style.vertically_stretchable = true
	preview.style.horizontally_stretchable = true

	preview.style.vertical_align = "center"
	preview.style.horizontal_align = "center"
	preview.style.width = 208
	preview.style.height = 20

	preview.style.color = entry.colorTool.color

	for channel, val in pairs(entry.colorTool.color) do
		local row = section.add({
			type = "flow",
			name = M.getName(entry, section, channel, "row"),
			direction = "horizontal",
		})

		local label = row.add({
			type = "label",
			name = M.getName(entry, row, "label"),
			caption = string.upper(channel),
		})
		local slider = row.add({
			type = "slider",
			name = M.getName(entry, row, "slider"),
			style = const.gui.sliderStyle .. channel,
			minimum_value = 0,
			maximum_value = 1,
			value_step = 0.001,
			value = val,
		})
		local text = row.add({
			type = "textfield",
			name = M.getName(entry, row, "value"),
			numeric = true,
			text = tostring(math.floor(val * 255)),
		})

		local total = 200
		local ratios = {
			label = 0.1,
			slider = 0.7,
			value = 0.2,
		}

		row.style.vertical_align = "center"

		label.style.width = total * ratios.label
		label.style.horizontal_align = "center"
		label.style.vertical_align = "center"

		slider.style.width = total * ratios.slider
		slider.style.top_margin = 2
		slider.style.vertical_align = "center"
		slider.style.horizontal_align = "center"

		text.style.width = total * ratios.value
		text.style.height = 20

		M.handlers[slider.name] = function(event)
			local newVal = event.element.slider_value
			entry.colorTool.color[channel] = newVal
			text.text = tostring(math.floor(newVal * 255))
			preview.style.color = entry.colorTool.color
		end
		M.handlers[text.name] = function(event)
			local newVal = tonumber(event.element.text)
			if not newVal then
				newVal = 0
			elseif newVal > 255 then
				newVal = 255
			elseif newVal < 0 then
				newVal = 0
			end
			text.text = tostring(newVal)

			newVal = newVal / 255
			entry.colorTool.color[channel] = newVal
			slider.slider_value = newVal
			preview.style.color = entry.colorTool.color
		end
	end

	local submit = frame.add({
		type = "button",
		name = M.getName(entry, frame, "submit"),
		caption = { "gui.color-tool-submit" },
		style = "confirm_button",
	})

	submit.style.horizontal_align = "center"
	submit.style.width = 230
	submit.style.height = 30

	M.handlers[submit.name] = function(event)
		M.close(entry)
		if entry.player.clear_cursor() then
			entry.player.cursor_stack.set_stack({ name = const.shortcut.tool })
		end
	end

	log(serpent.block(frame))
end

---@param entry Save.Player.Entry
M.close = function(entry)
	entry.player.gui.screen[M.getName(entry)].destroy()
end

return M
