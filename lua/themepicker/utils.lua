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

function M.get_buffer_by_name(name)
    local buffers = vim.api.nvim_list_bufs()
    for _, buffer in ipairs(buffers) do
        local buffer_path = vim.api.nvim_buf_get_name(buffer)
        local buffer_name = buffer_path:match("([^/]+)$")
        if buffer_name == name then return buffer end
    end
    return nil
end

function M.get_window_by_buffer(buffer)
    local windows = vim.api.nvim_list_wins()
    for _, win in ipairs(windows) do
        local winBuf = vim.api.nvim_win_get_buf(win)
        if winBuf == buffer then return win
        end
    end

    return nil
end

function M.get_namespace_by_name_or_new(name)
    local namespaces = vim.api.nvim_get_namespaces()
    for _, namespace in ipairs(namespaces) do
        if namespace.name == name then
            return namespace
        end
    end

    return vim.api.nvim_create_namespace("Themepicker")
end

function M.merge_config(base_config, new_config)
    return vim.tbl_deep_extend("force", base_config, new_config or {})
end

function M.diff_table_keys(start_table, end_table)
    local diff_table = {}

    for key, _ in pairs(end_table) do
        if start_table[key] == nil then
            table.insert(diff_table, key)
        end
    end

    return diff_table
end

function M.parse_string_table(str)
    -- striping all the values gone
    local formatted_str = "return "
    str = str:gsub("<1>", "")
    for line in str:gmatch("[^\r\n]+") do
        line = line:gsub("=.+$", "= '',")
        formatted_str = formatted_str .. line .. "\n"
    end

    return loadstring(formatted_str)()
end

return M
