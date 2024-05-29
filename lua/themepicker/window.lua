local utils = require("lua.themepicker.utils")
local config = require("lua.themepicker.config")
local themes = require("lua.themepicker.themes")
local keybinds = require("lua.themepicker.keybinds")

local M = {}

function M.renderWindow()
    local pickerBuffer = M.createBuffer("Themepicker")
    local mainOpts = {
        filetype = "Themepicker",
        bufhidden = "wipe",
    }
    M.configureBuffer(pickerBuffer, mainOpts)
    M.addColorThemes(pickerBuffer)

    local searchBuffer = M.createBuffer("ThemepickerSearchbar")
    local searchOpts = {}
    M.configureBuffer(searchBuffer, searchOpts)

    local buffers = {
        pickerBuffer = pickerBuffer,
        searchBuffer = searchBuffer,
    }
    local ui = M.createUI(buffers)

    for _, window in pairs(ui) do
        vim.api.nvim_win_set_option(window, 'wrap', false)
    end

    M.styleSearchBar()

    keybinds.bindKeys()

    vim.cmd("startinsert")

    local nCharacters = #vim.api.nvim_buf_get_lines(searchBuffer, 0, -1, false)[1]
    vim.api.nvim_win_set_cursor(0, {1, nCharacters})
end

function M.createBuffer(name)
    local buffer = vim.api.nvim_create_buf(false, true)

    local oldBuffer = utils.getBufferByName(name)
    if oldBuffer then
        vim.api.nvim_buf_delete(oldBuffer, { force = true })
    end

    vim.api.nvim_buf_set_name(buffer, name)

    return buffer
end

function M.configureBuffer(buffer, opts)
    for key, value in pairs(opts) do
        vim.api.nvim_buf_set_option(buffer, key, value)
    end
end

function M.addColorThemes(buffer)
    local colorSchemes = themes.getThemes()
    local bufferLines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)

    for i, colorScheme in ipairs(colorSchemes) do
        local lineIndex = #bufferLines + i - 1
        vim.api.nvim_buf_set_lines(buffer, lineIndex, lineIndex, false, {colorScheme})
    end
end

function M.createUI(buffers)
    local pickerBuffer = buffers.pickerBuffer
    local searchBuffer = buffers.searchBuffer

    local nvimWidth = vim.o.columns
    local nvimHeight = vim.o.lines

    local totalWidth = math.floor(nvimWidth * config.config.window.total_width)
    local totalHeight = math.floor(nvimHeight * config.config.window.total_height)

    local totalWindowX = math.floor(nvimWidth / 2 - totalWidth / 2)
    local totalWindowY = math.floor(nvimHeight / 2 - totalHeight / 2)

    local searchOpts = {
        width = totalWidth,
        height = (config.config.window.searchbar.height < 1) and math.floor(totalHeight * config.config.window.searchbar.height) or math.floor(config.config.window.searchbar.height),
        col = totalWindowX,
        row = totalWindowY,
        focusable = true,
    }

    local pickerWindowOpts = {
        width = totalWidth,
        height = totalHeight - searchOpts.height,
        col = totalWindowX,
        row = totalWindowY + searchOpts.height + config.config.window.searchbar.padding + 2,
        focusable = false,
    }

    local pickerWindow = M.createWindow(pickerBuffer, pickerWindowOpts)
    local searchWindow = M.createWindow(searchBuffer, searchOpts)

    return {
        searchWindow = searchWindow,
        pickerWindow = pickerWindow,
    }
end

function M.createWindow(buffer, opts)
    local windowOpts = {
        relative = config.config.window.relative,
        style = config.config.window.style,
        border = config.config.window.border,
    }

    local mergedOpts = utils.mergeConfig(windowOpts, opts)

    local window = vim.api.nvim_open_win(buffer, true, mergedOpts)

    return window
end

function M.styleSearchBar()
    local searchBuffer = utils.getBufferByName("ThemepickerSearchbar")
    local decorator = " " .. config.config.window.searchbar.search_decorator .. " "
    local nLines = #vim.api.nvim_buf_get_lines(searchBuffer, 0, -1, false)

    vim.api.nvim_buf_set_lines(searchBuffer, nLines - 1, nLines - 1, true, {decorator})
end

function M.closeWindow()
    local pickerBuffer = utils.getBufferByName("Themepicker")
    local searchBuffer = utils.getBufferByName("ThemepickerSearchbar")

    local pickerWindow = utils.getWinByBuffer(pickerBuffer)
    local searchWindow = utils.getWinByBuffer(searchBuffer)

    vim.api.nvim_win_close(pickerWindow, true)
    vim.api.nvim_win_close(searchWindow, true)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", false)
end

return M
