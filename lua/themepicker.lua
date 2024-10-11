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

local commands = require("themepicker.commands")

local M = {}

function M.setup(opts)
    _G.Themepicker = {}

    local user_config = utils.merge_config(defaults, opts)

    config.setup(user_config)

    commands.setup()
end

M.setup({})

return M
