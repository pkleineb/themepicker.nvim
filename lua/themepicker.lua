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
local defaults = require("themepicker.defaults")
local config = require("themepicker.config")
local loader = require("themepicker.loader")

local commands = require("themepicker.commands")

local M = {}

function M.setup(opts)
    _G.Themepicker = {}

    local user_config = utils.merge_config(defaults, opts)

    config.setup(user_config)

    commands.setup()

    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            vim.defer_fn(function()
                M.load_existing_color_scheme()
            end, 5)
        end,
        once = true,
    })
end

function M.load_existing_color_scheme()
    local color_scheme_data = utils.load_table_from_file(config.config.themes.save_theme_dir .. "/color_scheme_data.lua")
    if not color_scheme_data then return end

    loader.load_color_scheme(color_scheme_data.module_path, color_scheme_data.module_name, color_scheme_data.module_type)
end

return M
