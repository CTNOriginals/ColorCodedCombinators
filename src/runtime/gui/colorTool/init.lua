local const = require("shared.constants")

local M = {}

M.templates = require("runtime.gui.colorTool.templates")

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

	local frameName = const.gui.colorTool .. "-" .. entry.player.name
	local playerScreen = entry.player.gui.screen
	local existing = playerScreen[M.templates.frame:name(playerScreen, frameName)]
	if existing then
		existing.destroy()
	end

	local content = {
		width = 200,
		ratios = {
			label = 0.1,
			slider = 0.7,
			field = 0.2,
		},
	}

	local frame = M.templates.frame:build(entry.player.gui.screen, {
		definition = {
			name = frameName,
		},
	})
	local section = M.templates.section:build(frame)
	local preview = M.templates.preview:build(section, {
		style = {
			color = entry.colorTool.color,
		},
	})

	for channel, val in pairs(entry.colorTool.color) do
		local row = M.templates.row:build(section, {
			definition = {
				name = channel,
			},
		})
		local label = M.templates.label:build(row, {
			definition = {
				caption = string.upper(channel),
			},
			style = {
				width = content.width * content.ratios.label,
			},
		})
		local slider = M.templates.slider:build(row, {
			definition = {
				style = const.gui.sliderStyle .. channel,
				value = val,
			},
			style = {
				width = content.width * content.ratios.slider,
			},
		})
		local field = M.templates.field:build(row, {
			definition = {
				text = tostring(math.floor(val * 255)),
			},
			style = {
				width = content.width * content.ratios.field,
			},
		})

		M.handlers[slider.name] = function(event)
			local newVal = event.element.slider_value
			entry.colorTool.color[channel] = newVal
			field.text = tostring(math.floor(newVal * 255))
			preview.style.color = entry.colorTool.color
		end
		M.handlers[field.name] = function(event)
			local newVal = tonumber(event.element.text)
			if not newVal then
				newVal = 0
			elseif newVal > 255 then
				newVal = 255
			elseif newVal < 0 then
				newVal = 0
			end
			field.text = tostring(newVal)

			newVal = newVal / 255
			entry.colorTool.color[channel] = newVal
			slider.slider_value = newVal
			preview.style.color = entry.colorTool.color
		end
	end

	local submit = M.templates.submit:build(frame)

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
