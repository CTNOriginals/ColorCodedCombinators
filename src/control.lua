local storage = require("storage")
local const = require("constants")

log("-- loaded --")

script.on_init(storage.init)
script.on_configuration_changed(storage.init)
