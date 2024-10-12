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
local themes = require("themepicker.themes")
local window = require("themepicker.window")
local config = require("themepicker.config")

local M = {}

function M.apply_color_scheme()
    local picker_buffer = utils.get_buffer_by_name("Themepicker")
    if #vim.api.nvim_buf_get_lines(picker_buffer, 0, -1, false) == 1 and vim.api.nvim_buf_get_lines(picker_buffer, 0, -1, false)[1] == "" then return end

    local scheme_path, scheme_name, module_type = unpack(M.get_color_scheme_under_selection())

    M.load_color_scheme(scheme_path, scheme_name, module_type)

    utils.save_table_to_file({
        module_path = scheme_path,
        module_name = scheme_name,
        module_type = module_type,
    }, config.config.themes.save_theme_dir .. "/color_scheme_data.lua")
end

function M.get_color_scheme_under_selection()
    local picker_buffer = utils.get_buffer_by_name("Themepicker")
    if not picker_buffer then error("Couldnt retrieve the right picker_buffer. Try restarting vim") end

    local win = utils.get_window_by_buffer(picker_buffer)
    if not win then error("Couldnt retrieve the right window. Try restarting vim") end

    local row = _G.Themepicker.current_highlight_line

    local theme = vim.api.nvim_buf_get_lines(picker_buffer, 0, -1, false)[row + 1]
    local escaped_theme = theme:gsub("%-", "%%-")

    local color_scheme_paths = themes.get_color_scheme_paths()

    local color_scheme_path = ""
    local module_type = ""
    for _, path in ipairs(color_scheme_paths) do
        if path:match(".+" .. escaped_theme .. ".+") then
            module_type = path:match("([^/]+)$")
            module_type = module_type:match("[^.]+%.(.+)$")
            color_scheme_path = path:gsub("colors.*$", "colors/")
            break
        end
    end

    return { color_scheme_path, theme, module_type }
end

function M.load_color_scheme(module_path, module_name, module_type)
    local pattern = "(/[^/]*)(/[^/]*)$"
    local plugin_path = module_path:gsub(pattern, "")
    vim.opt.rtp:append(plugin_path)

    local before_load_packages = utils.parse_string_table(vim.inspect(package.loaded, { depth = 1 }))

    vim.cmd("source " .. module_path .. module_name .. "." .. module_type)
    vim.cmd("colorscheme " .. module_name)

    local after_load_packages = utils.parse_string_table(vim.inspect(package.loaded, { depth = 1 }))

    local new_loaded_plugins = utils.diff_table_keys(before_load_packages, after_load_packages)

    if vim.g.active_theme ~= nil then
        vim.opt.rtp:remove(vim.g.active_theme.plugin_path)
        for _, plugin in ipairs(vim.g.active_theme.loaded_plugins) do
            package.loaded[plugin] = nil
        end
    end

    vim.g.active_theme = {
        plugin_path = plugin_path,
        loaded_plugins = new_loaded_plugins,
    }

    if utils.get_buffer_by_name("Themepicker") then
        window.set_highlight(_G.Themepicker.current_highlight_line)
    end
end

return M
