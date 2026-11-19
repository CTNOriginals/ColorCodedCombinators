---@alias EventNameType defines.events|string
---@alias EventCallback fun(event: EventData)

local M = {}

---@type table<EventNameType, EventCallback[]>
local eventHandlers = {}

---@param eventName EventNameType
local function handleEvent(eventName)
	script.on_event(eventName, function(event)
		local callbacks = eventHandlers[eventName]

		for _, fn in ipairs(callbacks) do
			fn(event)
		end
	end)
end

---@param eventName EventNameType
---@param fn EventCallback
M.register = function(eventName, fn)
	local handlers = eventHandlers[eventName]

	if not handlers then
		handlers = {}
		eventHandlers[eventName] = handlers
		handleEvent(eventName)
	end

	table.insert(handlers, fn)
end

return M
