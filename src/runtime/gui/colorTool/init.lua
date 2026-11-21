local const = require("shared.constants")

local M = {
	templates = require("runtime.gui.colorTool.templates"),
}

---@type table<string, fun(event: OnGuiEvent.Data)>
M.handlers = {}

---@type fun(entry: Save.Player.Entry): LuaGuiElement?
M.get = function(entry)
	local screen = entry.player.gui.screen
	local name = M.templates.frame:name(screen, const.gui.colorTool .. "-" .. entry.player.name)
	return screen[name]
end

---@param entry Save.Player.Entry
M.open = function(entry)
	if not entry.player.valid then
		return
	end

	local existing = M.get(entry)
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

	M.screen = M.templates.frame:build(entry.player.gui.screen, {
		definition = {
			name = const.gui.colorTool .. "-" .. entry.player.name,
		},
	})

	local section = M.templates.section:build(M.screen)
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
				tags = { channel = channel },
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

		-- M.handlers[slider.name] = function(event)
		-- 	local newVal = event.element.slider_value
		-- 	entry.colorTool.color[channel] = newVal
		-- 	field.text = tostring(math.floor(newVal * 255))
		-- 	preview.style.color = entry.colorTool.color
		-- end
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

	local submit = M.templates.submit:build(M.screen)

	M.handlers[submit.name] = function(event)
		M.close(entry)
		if entry.player.clear_cursor() then
			entry.player.cursor_stack.set_stack({ name = const.shortcut.tool })
		end
	end
end

---@param entry Save.Player.Entry
M.close = function(entry)
	local ui = M.get(entry)

	if not ui then
		return
	end

	ui.destroy()
end

return M
