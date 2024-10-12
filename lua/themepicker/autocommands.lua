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

local M = {}

M.auto_commands = {
}

function M.set_auto_commands()
    local augroup = vim.api.nvim_create_augroup("Themepicker", { clear = true })

    for _, command in ipairs(M.auto_commands) do
        local config = vim.tbl_deep_extend("force", command.config, { group = augroup })
        vim.api.nvim_create_autocmd(
            command.event,
            config
        )
    end
end

return M
