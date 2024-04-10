local utils = require("lua.themepicker.utils")
local defaults = require("lua.themepicker.defaults")
local window = require("lua.themepicker.commands")
local commands = require("lua.themepicker.commands")

local M = {}

function M.setup(config)
    local userConfig = utils.mergeConfig(defaults, config)

    window.setup(userConfig)

    commands.setup()
end

M.setup({})

return M
