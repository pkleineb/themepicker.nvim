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

function M.save_table_to_file(tbl, file_name)
    local file = io.open(file_name, "w")
    if not file then return false end

    file:write(M.serialize_table(tbl))
    file:close()

    return true
end

function M.serialize_table(tbl)
    local result = "return {"
    for key, value in pairs(tbl) do
        local serialized_key = type(key) == "number" and "[" .. key .. "]" or "['" .. tostring(key) .. "']"
        if type(value) == "table" then
            result = result .. serialized_key .. "=" .. M.serialize(value) .. ","
        elseif type(value) == "string" then
            result = result .. serialized_key .. "='" .. value:gsub("'", "\\'") .. "',"
        else
            result = result .. serialized_key .. "=" .. tostring(value) .. ","
        end
    end
    return result .. "}"
end

function M.load_table_from_file(file_name)
    local file = io.open(file_name, "r")
    if not file then return nil end

    local content = file:read("*all")
    file:close()

    local return_value = loadstring(content)
    if return_value then
        return return_value()
    end

    return nil
end

return M
