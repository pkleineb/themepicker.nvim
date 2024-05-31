local utils = require("themepicker.utils")
local config = require("themepicker.config")

local M = {}

function M.bindKeys()
    local themepickerBuffer = utils.getBufferByName("ThemepickerSearchbar")

    if not themepickerBuffer then
        error("Couldn't find the Themepicker buffer")
        return
    end

    for _, keymap in ipairs(config.config.keys) do
        if type(keymap.mode) == "table" then
            for _, mode in ipairs(keymap.mode) do
                vim.api.nvim_buf_set_keymap(themepickerBuffer, mode, keymap.keys, keymap.command, keymap.opts)
            end
            goto continue
        end
        vim.api.nvim_buf_set_keymap(themepickerBuffer, keymap.mode, keymap.keys, keymap.command, keymap.opts)

        ::continue::
    end
end

return M
