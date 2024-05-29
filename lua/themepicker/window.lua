local utils = require("lua.themepicker.utils")
local config = require("lua.themepicker.config")
local themes = require("lua.themepicker.themes")
local keybinds = require("lua.themepicker.keybinds")

local M = {}

function M.renderWindow()
    -- Create a new buffer
    local buffer = vim.api.nvim_create_buf(false, true)

    local oldBuffer = utils.getBufferByName("Themepicker")
    if oldBuffer then
        vim.api.nvim_buf_delete(oldBuffer, { force = true })
    end

    vim.api.nvim_buf_set_name(buffer, "Themepicker")
    vim.api.nvim_set_option_value("filetype", "Themepicker", { buf = buffer })
    vim.api.nvim_buf_set_option(buffer, 'bufhidden', 'wipe')

    local colorSchemes = themes.getThemes()

    for i, colorScheme in ipairs(colorSchemes) do
        vim.api.nvim_buf_set_lines(buffer, i - 1, i - 1, false, {colorScheme})
    end

    local nvimWidth = vim.o.columns
    local nvimHeight = vim.o.lines

    local width = math.floor(nvimWidth * config.config.window.width)
    local height = math.floor(nvimHeight * config.config.window.height)

    local windowX = math.floor(nvimWidth / 2 - width / 2)
    local windowY = math.floor(nvimHeight / 2 - height / 2)

    local window_opts = {
        relative = config.config.window.relative,
        width = width,
        height = height,
        row = windowY,
        col = windowX,
        style = config.config.window.style,
        border = config.config.window.border,
    }

    local window = vim.api.nvim_open_win(buffer, true, window_opts)

    vim.api.nvim_win_set_option(window, 'wrap', false)

    keybinds.bindKeys()

    vim.api.nvim_set_option_value("modifiable", false, { buf = buffer })
end

function M.closeWindow()
    local pickerBuf = utils.getBufferByName("Themepicker")

    local win = utils.getWinByBuffer(pickerBuf)

    vim.api.nvim_win_close(win, true)
end

return M
