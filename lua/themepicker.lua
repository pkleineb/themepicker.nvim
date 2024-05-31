local utils = require("lua.themepicker.utils")
local defaults = require("lua.themepicker.defaults")
local config = require("lua.themepicker.config")

local commands = require("lua.themepicker.commands")

local M = {}

function M.setup(opts)
    _G.Themepicker = {}
    local userConfig = utils.mergeConfig(defaults, opts)

    config.setup(userConfig)

    commands.setup()
end

M.setup({})

return M
