local utils = require("lua.themepicker.utils")
local defaults = require("lua.themepicker.defaults")

local window = require("lua.themepicker.window")
local keybinds = require("lua.themepicker.keybinds")
local loader = require("lua.themepicker.loader")

local commands = require("lua.themepicker.commands")

local M = {}

function M.setup(config)
    local userConfig = utils.mergeConfig(defaults, config)

    window.setup(userConfig.window)
    keybinds.setup(userConfig.keys)

    commands.setup()
end

M.setup({})

return M
