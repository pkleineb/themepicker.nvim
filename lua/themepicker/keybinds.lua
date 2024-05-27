local utils = require("lua.themepicker.utils")

local M = {}

function M.bindKeys()
    local themepickerBuffer = utils.getBufferByName("Themepicker")

    if not themepickerBuffer then
        error("Couldn't find the Themepicker buffer")
        return
    end
    
    for _, keymap in ipairs(M.config) do
        vim.api.nvim_buf_set_keymap(themepickerBuffer, keymap.mode, keymap.keys, keymap.command, keymap.opts)
    end
end

function M.setup(config)
    M.config = config
end

return M
