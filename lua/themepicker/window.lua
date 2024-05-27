local utils = require("lua.themepicker.utils")
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

    local colorSchemes = themes.getThemes()

    -- Set some text in the buffer
    for i, colorScheme in ipairs(colorSchemes) do
        vim.api.nvim_buf_set_lines(buffer, i - 1, i - 1, false, {colorScheme})
    end

    local nvimWidth = vim.o.columns
    local nvimHeight = vim.o.lines

    local width = math.floor(nvimWidth / 2)
    local height = math.floor(nvimHeight / 2)

    local windowX = math.floor(nvimWidth / 2 - width / 2)
    local windowY = math.floor(nvimHeight / 2 - height / 2)

    -- Define the floating window configuration
    local window_opts = {
        relative = 'editor', -- This makes the window floating
        width = width,
        height = height,
        row = windowY,
        col = windowX,
        style = 'minimal',
    }

    -- Open the floating window
    local win = vim.api.nvim_open_win(buffer, true, window_opts)

    keybinds.bindKeys()

    vim.api.nvim_set_option_value("modifiable", false, { buf = buffer })
end

function M.setup(config)
    M.config = config
end

return M
