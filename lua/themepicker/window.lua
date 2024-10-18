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
local themes = require("themepicker.themes")
local keybinds = require("themepicker.keybinds")
local autocmds = require("themepicker.autocommands")

local M = {}

function M.render_window()
    M.set_color_schemes()

    local picker_buffer = M.create_buffer("Themepicker")
    local main_opts = {
        filetype = "Themepicker",
        bufhidden = "wipe",
    }
    M.configure_buffer(picker_buffer, main_opts)
    M.add_color_themes(picker_buffer)

    M.init_highlight()

    local search_buffer = M.create_buffer("ThemepickerSearchbar")
    local search_opts = {}
    M.configure_buffer(search_buffer, search_opts)

    local buffers = {
        picker_buffer = picker_buffer,
        search_buffer = search_buffer,
    }
    local ui = M.create_ui(buffers)

    for _, window in pairs(ui) do
        vim.api.nvim_win_set_option(window, 'wrap', false)
    end

    keybinds.bind_keys()

    M.set_auto_commands()

    vim.cmd("startinsert")

    M.style_search_bar("")

    -- stupid again just need to wait a lil to set highlight, since that can only be done after window is rendered ig
    vim.defer_fn(function()
            M.set_highlight(0)
        end,
        5
    )
end

function M.create_buffer(name)
    local buffer = vim.api.nvim_create_buf(false, true)

    local old_buffer = utils.get_buffer_by_name(name)
    if old_buffer then
        vim.api.nvim_buf_delete(old_buffer, { force = true })
    end

    vim.api.nvim_buf_set_name(buffer, name)

    return buffer
end

function M.configure_buffer(buffer, opts)
    for key, value in pairs(opts) do
        vim.api.nvim_buf_set_option(buffer, key, value)
    end
end

function M.add_color_themes(buffer)
    M.set_color_schemes()

    vim.api.nvim_buf_set_lines(buffer, 0, #M.color_schemes, false, M.color_schemes)
end

function M.set_color_schemes()
    M.color_schemes = themes.get_themes()
end

function M.create_ui(buffers)
    local picker_buffer = buffers.picker_buffer
    local search_buffer = buffers.search_buffer

    local nvim_width = vim.o.columns
    local nvim_height = vim.o.lines

    local total_width = math.floor(nvim_width * config.config.window.total_width)
    local total_height = math.floor(nvim_height * config.config.window.total_height)

    local total_window_x = math.floor(nvim_width / 2 - total_width / 2)
    local total_window_y = math.floor(nvim_height / 2 - total_height / 2)

    local search_opts = {
        width = total_width,
        height = (config.config.window.searchbar.height < 1) and math.floor(total_height * config.config.window.searchbar.height) or math.floor(config.config.window.searchbar.height),
        col = total_window_x,
        row = total_window_y,
        focusable = true,
    }

    local picker_window_opts = {
        width = total_width,
        height = total_height - search_opts.height,
        col = total_window_x,
        row = total_window_y + search_opts.height + config.config.window.searchbar.padding + 2,
        --focusable = false,
    }

    local picker_window = M.create_window(picker_buffer, picker_window_opts)
    local search_window = M.create_window(search_buffer, search_opts)

    return {
        search_window = search_window,
        picker_window = picker_window,
    }
end

function M.create_window(buffer, opts)
    local window_opts = {
        relative = config.config.window.relative,
        style = config.config.window.style,
        border = config.config.window.border,
    }

    local merged_opts = utils.merge_config(window_opts, opts)

    local window = vim.api.nvim_open_win(buffer, true, merged_opts)

    return window
end

function M.style_search_bar(content)
    local search_buffer = utils.get_buffer_by_name("ThemepickerSearchbar")
    local decorator = " " .. config.config.window.searchbar.search_decorator .. " "
    local escaped_content = content:gsub(decorator, "")

    vim.api.nvim_buf_set_lines(search_buffer, 0, -1, false, {#content > 3 and decorator .. escaped_content or decorator})
end

function M.close_window()
    local picker_buffer = utils.get_buffer_by_name("Themepicker")
    local search_buffer = utils.get_buffer_by_name("ThemepickerSearchbar")

    local picker_window = utils.get_window_by_buffer(picker_buffer)
    local search_window = utils.get_window_by_buffer(search_buffer)

    vim.api.nvim_win_close(picker_window, true)
    vim.api.nvim_win_close(search_window, true)
    vim.api.nvim_clear_autocmds({ group = vim.api.nvim_create_augroup("Themepicker", { clear = false }) })
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end

function M.handle_insert()
    local search_buffer = utils.get_buffer_by_name("ThemepickerSearchbar")
    local search_window = utils.get_window_by_buffer(search_buffer)

    if vim.api.nvim_win_get_cursor(search_window)[2] > 4 then return end

    -- have to delay this since insert mode will place at the position where insert was pressed and we need to set the pos later
    vim.defer_fn(function()
            vim.api.nvim_win_set_cursor(search_window, {1, 4})
        end,
        5
    )
end

function M.handle_input()
    local search_buffer = utils.get_buffer_by_name("ThemepickerSearchbar")

    if not search_buffer then
        -- instead of returning might need to unbind
        return
    end

    local search_content = vim.api.nvim_buf_get_lines(search_buffer, 0, -1, false)

    if #search_content > -1 then
        vim.api.nvim_buf_set_lines(search_buffer, 0, -1, true, {search_content[1]})
    end

    M.style_search_bar(search_content[1])
    local num_characters = #vim.api.nvim_buf_get_lines(search_buffer, 0, -1, false)[1]
    vim.api.nvim_win_set_cursor(0, {1, num_characters})

    M.search_for_theme(search_content[1])

    M.set_highlight(0)
end

function M.search_for_theme(search_content)
    local picker_buffer = utils.get_buffer_by_name("Themepicker")
    local formatted_search = search_content:sub(4)

    local matches = {}
    for _, theme in ipairs(M.color_schemes) do
        if M.fuzzy_match(formatted_search, theme) then
            table.insert(matches, theme)
        end
    end

    vim.api.nvim_buf_set_lines(picker_buffer, 0, #vim.api.nvim_buf_get_lines(picker_buffer, 0, -1, false), true, matches)
end

function M.fuzzy_match(query, str)
    local query_len = #query
    local str_len = #str
    local query_index = 1
    local str_index = 1

    while query_index <= query_len and str_index <= str_len do
        if query:sub(query_index, query_index):lower() == str:sub(str_index, str_index):lower() then
            query_index = query_index + 1
        end
        str_index = str_index + 1
    end

    return query_index > query_len
end

function M.set_auto_commands()
    local window_auto_commands = {
        {
            event = "TextChangedI",
            config = {
                buffer = utils.get_buffer_by_name("ThemepickerSearchbar"),
                callback = M.handle_input,
            },
        },
        {
            event = "TextChanged",
            config = {
                buffer = utils.get_buffer_by_name("ThemepickerSearchbar"),
                callback = M.handle_input,
            },
        },
        {
            event = "InsertEnter",
            config = {
                buffer = utils.get_buffer_by_name("ThemepickerSearchbar"),
                callback = M.handle_insert,
            }
        },
    }

    autocmds.auto_commands = vim.tbl_deep_extend("force", autocmds.auto_commands, window_auto_commands)
    autocmds.set_auto_commands()
end

function M.init_highlight()
    _G.Themepicker.current_highlight_line = -1
    _G.Themepicker.namespace = utils.get_namespace_by_name_or_new("Themepicker")
end

function M.set_highlight(line)
    local picker_buffer = utils.get_buffer_by_name("Themepicker")

    if line >= #vim.api.nvim_buf_get_lines(picker_buffer, 0, -1, false) then
        line = 0
    end

    if line < 0 then
        line = #vim.api.nvim_buf_get_lines(picker_buffer, 0, -1, false) - 1
    end

    local namespace = _G.Themepicker.namespace

    vim.api.nvim_buf_clear_namespace(picker_buffer, namespace, 0, -1)

    M.create_highlight_groups()

    vim.api.nvim_buf_set_extmark(
        picker_buffer,
        namespace,
        line,
        0,
        {
            end_line = line + 1,
            hl_group = (vim.o.background == "dark") and "ThemepickerDark" or "ThemepickerLight",
        }
    )

    _G.Themepicker.current_highlight_line = line
end

function M.create_highlight_groups()
    local light_args = (type(config.config.window.highlights.light.additional_args) == "string") and config.config.window.highlights.light.additional_args or table.concat(config.config.window.highlights.light.additional_args, " ")
    local dark_args = (type(config.config.window.highlights.dark.additional_args) == "string") and config.config.window.highlights.dark.additional_args or table.concat(config.config.window.highlights.dark.additional_args, " ")

    vim.cmd([[highlight ThemepickerLight guifg=]] .. config.config.window.highlights.light.guifg .. [[ guibg=]] .. config.config.window.highlights.light.guibg .. [[ gui=bold]] .. light_args)
    vim.cmd([[highlight ThemepickerDark guifg=]] .. config.config.window.highlights.dark.guifg .. [[ guibg=]] .. config.config.window.highlights.dark.guibg .. [[ gui=bold]] .. dark_args)
end

function M.next_selection()
    M.set_highlight(_G.Themepicker.current_highlight_line + 1)
end

function M.previous_selection()
    M.set_highlight(_G.Themepicker.current_highlight_line - 1)
end

return M
