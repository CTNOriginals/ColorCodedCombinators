local const = require("constants")

local M = {}
M.prefix = "color-tool-"

---@param entry Save.Player.Entry
---@param trail string[]?
---@return string
M.getName = function(entry, trail)
	local name = const.guiPrefix .. M.prefix .. entry.player.name

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
end

return M
