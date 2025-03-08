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
local config = require("themepicker.config")

local M = {}

function M.invalid_selection(buffer)
    local lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)

    return #lines == 1 and lines[1] == ""
end

function M.apply_color_scheme()
    local picker_buffer = utils.get_buffer_by_name("Themepicker")
    if M.invalid_selection(picker_buffer) then return end

    local scheme_name = M.get_color_scheme_under_selection()

    local scheme_path, module_type = unpack(M.get_color_scheme_data(scheme_name))

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

    local colorschemes = vim.api.nvim_buf_get_lines(picker_buffer, 0, -1, false)
    local current_highlight_line = _G.Themepicker.current_highlight_line

    local highlighted_colorscheme = colorschemes[current_highlight_line + 1]

    return highlighted_colorscheme
end

function M.get_color_scheme_data(colorscheme)
    local color_scheme_paths = themes.get_color_scheme_paths()
    local escaped_colorscheme = colorscheme:gsub("%-", "%%-")

    for _, path in ipairs(color_scheme_paths) do
        if path:match(".+" .. escaped_colorscheme .. ".+") then
            local module_type = path:match("([^/]+)$")
            module_type = module_type:match("[^.]+%.(.+)$")

            local color_scheme_path = path:gsub("colors.*$", "colors/")

            return { color_scheme_path, module_type }
        end
    end
end

function M.load_color_scheme(module_path, module_name, module_type)
    M.add_plugin_path_to_rtp(module_path)

    local before_load_packages = utils.parse_string_table(vim.inspect(package.loaded, { depth = 1 }))

    vim.cmd("source " .. module_path .. module_name .. "." .. module_type)
    vim.cmd("colorscheme " .. module_name)

    local after_load_packages = utils.parse_string_table(vim.inspect(package.loaded, { depth = 1 }))

    local new_loaded_plugins = utils.diff_table_keys(before_load_packages, after_load_packages)
    if new_loaded_plugins == {} then return end

    if vim.g.active_theme ~= nil then M.unload_plugin(vim.g.active_theme) end

    M.save_plugin("active_theme", module_path, new_loaded_plugins)
end

function M.add_plugin_path_to_rtp(plugin_path)
    local pattern = "(/[^/]*)(/[^/]*)$"
    local plugin_path = plugin_path:gsub(pattern, "")
    vim.opt.rtp:append(plugin_path)
end

function M.unload_plugin(plugin_data)
    vim.opt.rtp:remove(plugin_data.plugin_path)
    for _, plugin in ipairs(plugin_data.loaded_plugins) do
        package.loaded[plugin] = nil
    end
end

function M.save_plugin(var_name, plugin_path, loaded_plugins)
    vim.g[var_name] = {
        plugin_path = plugin_path,
        loaded_plugins = loaded_plugins,
    }
end

function M.apply_color_scheme_to_buffer(buffer)
    local picker_buffer = utils.get_buffer_by_name("Themepicker")
    if M.invalid_selection(picker_buffer) then return end

    local scheme_name = M.get_color_scheme_under_selection()
    local scheme_path, module_type = unpack(M.get_color_scheme_data(scheme_name))

    local buffer_window = utils.get_window_by_buffer(buffer)

    M.load_color_scheme_to_window(scheme_path, scheme_name, module_type, buffer_window)
end

function M.load_color_scheme_to_window(module_path, module_name, module_type, window)
    M.add_plugin_path_to_rtp(module_path)

    local before_load_packages = utils.parse_string_table(vim.inspect(package.loaded, { depth = 1 }))
    local current_color_scheme = vim.g.colors_name

    local preview_window_namespace = utils.get_namespace_by_name_or_new("preview_buffer_namespace")
    local current_background = vim.o.background

    vim.cmd("source " .. module_path .. module_name .. "." .. module_type)

    local after_load_packages = utils.parse_string_table(vim.inspect(package.loaded, { depth = 1 }))

    local highlights = M.get_highlights()
    M.set_highlights_for_namespace(preview_window_namespace, highlights)

    if current_color_scheme ~= nil then
        vim.cmd("colorscheme " .. current_color_scheme)
    else
        vim.cmd("colorscheme default")
    end
    vim.o.background = current_background

    vim.api.nvim_win_set_hl_ns(window, preview_window_namespace)

    local new_loaded_plugins = utils.diff_table_keys(before_load_packages, after_load_packages)
    if vim.tbl_isempty(new_loaded_plugins) then return end

    if vim.g.preview_theme ~= nil then M.unload_plugin(vim.g.preview_theme) end

    M.save_plugin("preview_theme", module_path, new_loaded_plugins)
end

function M.get_highlights()
    local highlights = {}
    local namespaces = vim.api.nvim_get_namespaces()

    highlights = vim.tbl_deep_extend("keep", highlights, vim.api.nvim_get_hl(0, {}))

    for _, id in pairs(namespaces) do
        highlights = vim.tbl_deep_extend("keep", highlights, vim.api.nvim_get_hl(id, {}))
    end

    return highlights
end

function M.set_highlights_for_namespace(namespace, highlights)
    for group, highlight in pairs(highlights) do
        vim.api.nvim_set_hl(namespace, group, highlight)
    end
end

return M
