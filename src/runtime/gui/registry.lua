local M = {}

---@type table<string, GuiTemplate>
M.templates = {}

---@type fun(element: LuaGuiElement): GuiTemplate
function M.getTemplate(element)
	local templateId = element.tags.template
	local template = M.templates[templateId]

	if not templateId or not template then
		error("Invalid template id: " .. templateId)
	end

	return template
end

return M
