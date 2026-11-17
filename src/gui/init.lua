local const = require("constants")
local utils = require("utils")

local M = {}
M.name = const.gui.prefix .. "color-picker"
M.color = utils.NewColor(0, 0, 0, 0)

local function elementName(name)
	return M.name .. "-" .. name
end

---@param player LuaPlayer
---@return LuaGuiElement?
M.get = function(player)
	return player.gui.screen[M.name]
end

---@type table<string, fun(event: EventData.on_gui_click)>
M.handlers = {}

---@param player LuaPlayer
M.open = function(player)
	local existing = M.get(player)
	if existing then
		log("reloading gui")
		existing.destroy()
	end

	-- everything in gui.screen is a free floating window
	local frame = player.gui.screen.add({
		type = "frame",
		name = M.name,
		caption = { "ccc-gui.title" },
		direction = "vertical",
	})
	frame.auto_center = true

	local opts = { "r", "g", "b" }
	---@type LuaGuiElement[]
	local checks = {}

	for _, name in pairs(opts) do
		local box = frame.add({ type = "checkbox", name = elementName(name), state = false, caption = name })
		table.insert(checks, box)
	end

	local submit = frame.add({
		type = "button",
		name = elementName("submit"),
		caption = "confirm",
	})

	M.handlers[submit.name] = function(event)
		local rgb = {}
		for _, box in pairs(checks) do
			local val = 0
			if box.state then
				val = 1
			end
			table.insert(rgb, val)
		end

		local color = utils.NewColor(rgb[1], rgb[2], rgb[3], 0.5)
		log(serpent.line(color))
		M.color = color
		if player.clear_cursor() then
			player.cursor_stack.set_stack({ name = const.shortcut.tool, count = 1 })
		end
		M.close(player)
	end
end

---@param player LuaPlayer
M.close = function(player)
	local frame = M.get(player)
	if not frame then
		return
	end
	frame.destroy()
end

---@param event EventData.on_gui_click
M.onClick = function(event)
	local callback = M.handlers[event.element.name]
	if not callback then
		return
	end
	callback(event)
end

---@param event EventData.on_gui_closed
M.onClosed = function(event)
	-- TODO
end

script.on_event(defines.events.on_gui_click, M.onClick)

return M
