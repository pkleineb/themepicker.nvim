local utils = require("themepicker.utils")
local defaults = require("themepicker.defaults")
local config = require("themepicker.config")

local commands = require("themepicker.commands")

local M = {}

function M.setup(opts)
    _G.Themepicker = {}

    local user_config = utils.merge_config(defaults, opts)

    config.setup(user_config)

    commands.setup()
end

M.setup({})

return M
