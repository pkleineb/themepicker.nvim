-- Copyright (C) <2024>  <Paul Kleineberg>

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
