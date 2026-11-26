local template = require("runtime.gui.template.init")
local save = require("runtime.save.init")

---@type table<string, GuiTemplate>
local M = {}

M.frame = template.new({
	---@type LuaGuiElement.add_param.frame
	definition = {
		type = "frame",
		caption = { "gui.color-tool-title" },
		direction = "vertical",
	},
	properties = {
		auto_center = true,
	},
})
M.section = template.new({
	---@type LuaGuiElement.add_param.frame
	definition = {
		type = "frame",
		direction = "vertical",
	},
})
M.preview = template.new({
	---@type LuaGuiElement.add_param.progressbar
	definition = {
		type = "progressbar",
		direction = "vertical",
		value = 1,
	},
	style = {
		bar_width = 25,
		vertically_stretchable = true,
		horizontally_stretchable = true,

		vertical_align = "center",
		horizontal_align = "center",
		-- width = 208,
		height = 20,
	},
})
M.row = template.new({
	---@type LuaGuiElement.add_param.flow
	definition = {
		type = "flow",
		direction = "horizontal",
	},
	style = {
		vertical_align = "center",
	},
})
M.label = template.new({
	---@type LuaGuiElement.add_param
	definition = {
		type = "label",
	},
	style = {
		horizontal_align = "center",
		vertical_align = "center",
	},
})
M.slider = template.new({
	---@type LuaGuiElement.add_param.slider
	definition = {
		type = "slider",
		minimum_value = 0,
		maximum_value = 1,
		value_step = 0.001,
	},
	style = {
		top_margin = 2,
		vertical_align = "center",
		horizontal_align = "center",
	},
	events = {
		on_gui_value_changed = function(_, ctx)
			local val = ctx.element.slider_value

			local field = ctx:getParent():getElement(M.field)
			local preview = ctx:getRoot():getElement(M.preview)

			field.element.text = tostring(math.floor(val * 255))
			ctx.playerEntry.colorTool.color[ctx.element.tags.channel] = val
			preview.element.style.color = ctx.playerEntry.colorTool.color
		end,
	},
})
M.field = template.new({
	---@type LuaGuiElement.add_param.textfield
	definition = {
		type = "textfield",
		numeric = true,
	},
	style = {
		height = 20,
	},
	events = {
		on_gui_text_changed = function(event, ctx)
			log(event.name)
			local val = tonumber(ctx.element.text)

			if not val then
				val = 0
			elseif val > 255 then
				val = 255
			elseif val < 0 then
				val = 0
			end
			ctx.element.text = tostring(val)

			local slider = ctx:getParent():getElement(M.slider)
			local preview = ctx:getRoot():getElement(M.preview)

			slider.element.slider_value = tostring(val / 255)
			ctx.playerEntry.colorTool.color[ctx.element.tags.channel] = val / 255
			preview.element.style.color = ctx.playerEntry.colorTool.color
		end,
	},
})
M.submit = template.new({
	---@type LuaGuiElement.add_param.button
	definition = {
		type = "button",
		name = "submit",
		caption = { "gui.color-tool-submit" },
		style = "confirm_button",
	},
	style = {
		horizontal_align = "center",
		width = 230,
		height = 30,
	},
})

return M
