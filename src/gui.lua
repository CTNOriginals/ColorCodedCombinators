local M = {}

local FRAME_NAME = "ccc-color-picker"

---@param player LuaPlayer
M.open = function(player)
	local existing = player.gui.screen[FRAME_NAME]
	if existing then
		log("reloading gui")
		existing.destroy()
	end

	-- everything in gui.screen is a free floating window
	local frame = player.gui.screen.add({
		type = "frame",
		name = FRAME_NAME,
		caption = { "ccc-gui.title" },
		direction = "vertical",
	})
	frame.auto_center = true

	-- TODO: add the content of the window
end

---@param player LuaPlayer
M.close = function(player)
	-- TODO
end

---@param event EventData.on_gui_click
M.onClick = function(event)
	-- TODO
end

---@param event EventData.on_gui_closed
M.onClosed = function(event)
	-- TODO
end

return M
