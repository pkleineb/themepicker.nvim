local utils = require("themepicker.utils")
local defaults = require("themepicker.defaults")
local config = require("themepicker.config")

local commands = require("themepicker.commands")

local M = {}

function M.setup(opts)
    _G.Themepicker = {}

    local userConfig = utils.mergeConfig(defaults, opts)

    config.setup(userConfig)

    commands.setup()
end

M.setup({})

return M
