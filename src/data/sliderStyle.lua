local const = require("constants")

local styles = data.raw["gui-style"].default

---@param channel string
---@param tint Color
local function sliderStyle(channel, tint)
	local bar = table.deepcopy(styles.slider.full_bar)
	bar.base = { position = { 313, 48 }, corner_size = 8, tint = tint }

	styles[const.gui.sliderStyle .. channel] = {
		type = "slider_style",
		parent = "slider",
		full_bar = bar,
	}
end

sliderStyle("r", { 1, 0, 0 })
sliderStyle("g", { 0, 1, 0 })
sliderStyle("b", { 0, 0, 1 })
sliderStyle("a", { 1, 1, 1 })
