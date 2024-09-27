local utils = require("themepicker.utils")
local config = require("themepicker.config")

local M = {}

function M.bind_keys()
    local themepicker_buffer = utils.get_buffer_by_name("ThemepickerSearchbar")

    if not themepicker_buffer then
        error("Couldn't find the Themepicker buffer")
        return
    end

    for _, keymap in ipairs(config.config.keys) do
        if type(keymap.mode) == "table" then
            for _, mode in ipairs(keymap.mode) do
                vim.api.nvim_buf_set_keymap(themepicker_buffer, mode, keymap.keys, keymap.command, keymap.opts)
            end
            goto continue
        end
        vim.api.nvim_buf_set_keymap(themepicker_buffer, keymap.mode, keymap.keys, keymap.command, keymap.opts)

        ::continue::
    end
end

return M
