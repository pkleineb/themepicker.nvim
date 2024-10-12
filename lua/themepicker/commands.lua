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

local window = require("themepicker.window")

local M = {}

M.commands = {
    {
        name = "ThemepickerRun",
        command = function()
            window.render_window()
        end,
        options = {},
    },
}

function M.setup()
    for _, command in ipairs(M.commands) do
        local options = vim.tbl_extend("force", command.options, { force = true })
        vim.api.nvim_create_user_command(command.name, command.command, options)
    end
end

return M
