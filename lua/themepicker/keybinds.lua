local utils = require("lua.themepicker.utils")
local config = require("lua.themepicker.config")

local M = {}

function M.bindKeys()
    local themepickerBuffer = utils.getBufferByName("Themepicker")

    if not themepickerBuffer then
        error("Couldn't find the Themepicker buffer")
        return
    end
    
    for _, keymap in ipairs(config.config.keys) do
        vim.api.nvim_buf_set_keymap(themepickerBuffer, keymap.mode, keymap.keys, keymap.command, keymap.opts)
    end
end

return M
