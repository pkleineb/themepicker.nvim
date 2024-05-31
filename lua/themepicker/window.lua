local utils = require("themepicker.utils")
local config = require("themepicker.config")
local themes = require("themepicker.themes")
local keybinds = require("themepicker.keybinds")
local autocmds = require("themepicker.autocommands")

local M = {}

function M.renderWindow()
    M.setColorSchemes()

    local pickerBuffer = M.createBuffer("Themepicker")
    local mainOpts = {
        filetype = "Themepicker",
        bufhidden = "wipe",
    }
    M.configureBuffer(pickerBuffer, mainOpts)
    M.addColorThemes(pickerBuffer)

    M.initHighlight()

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

    M.setAutoCommands()

    vim.cmd("startinsert")

    -- stupid again just need to wait a lil to set highlight, since that can only be done after window is rendered ig
    vim.defer_fn(function()
            M.setHighlight(0)
        end,
        5
    )
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
    M.setColorSchemes()

    vim.api.nvim_buf_set_lines(buffer, 0, #M.colorSchemes, false, M.colorSchemes)
end

function M.setColorSchemes()
    M.colorSchemes = themes.getThemes()
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
        --focusable = false,
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

    vim.api.nvim_buf_set_lines(searchBuffer, 0, -1, false, {decorator})
end

function M.closeWindow()
    local pickerBuffer = utils.getBufferByName("Themepicker")
    local searchBuffer = utils.getBufferByName("ThemepickerSearchbar")

    local pickerWindow = utils.getWinByBuffer(pickerBuffer)
    local searchWindow = utils.getWinByBuffer(searchBuffer)

    vim.api.nvim_win_close(pickerWindow, true)
    vim.api.nvim_win_close(searchWindow, true)
    vim.api.nvim_clear_autocmds({ group = vim.api.nvim_create_augroup("Themepicker", { clear = false }) })
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end

function M.handleInsert()
    local searchBuffer = utils.getBufferByName("ThemepickerSearchbar")
    local searchWindow = utils.getWinByBuffer(searchBuffer)

    if vim.api.nvim_win_get_cursor(searchWindow)[2] > 4 then return end

    -- have to delay this since insert mode will place at the position where insert was pressed and we need to set the pos later
    vim.defer_fn(function() 
            vim.api.nvim_win_set_cursor(searchWindow, {1, 4})
        end,
        5
    )
end

function M.handleInput()
    local searchBuffer = utils.getBufferByName("ThemepickerSearchbar")

    if not searchBuffer then
        -- instead of returning might need to unbind
        return
    end

    local searchContent = vim.api.nvim_buf_get_lines(searchBuffer, 0, -1, false)

    if #searchContent > -1 then
        vim.api.nvim_buf_set_lines(searchBuffer, 0, -1, true, {searchContent[1]})
    end

    if #searchContent[1] < 4 then
        M.styleSearchBar()
        local nCharacters = #vim.api.nvim_buf_get_lines(searchBuffer, 0, -1, false)[1]
        vim.api.nvim_win_set_cursor(0, {1, nCharacters})
    end

    M.searchForTheme(searchContent[1])

    M.setHighlight(0)
end

function M.searchForTheme(searchContent)
    local pickerBuffer = utils.getBufferByName("Themepicker")
    local formattedSearch = searchContent:sub(4)

    local matches = {}
    for _, theme in ipairs(M.colorSchemes) do
        if M.fuzzyMatch(formattedSearch, theme) then
            table.insert(matches, theme)
        end
    end

    vim.api.nvim_buf_set_lines(pickerBuffer, 0, #vim.api.nvim_buf_get_lines(pickerBuffer, 0, -1, false), true, matches)
end

function M.fuzzyMatch(query, str)
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

function M.setAutoCommands()
    local windowAutocommands = {
        {
            event = "TextChangedI",
            config = {
                buffer = utils.getBufferByName("ThemepickerSearchbar"),
                callback = M.handleInput,
            },
        },
        {
            event = "TextChanged",
            config = {
                buffer = utils.getBufferByName("ThemepickerSearchbar"),
                callback = M.handleInput,
            },
        },
        {
            event = "InsertEnter",
            config = {
                buffer = utils.getBufferByName("ThemepickerSearchbar"),
                callback = M.handleInsert,
            }
        },
    }

    autocmds.autoCommands = vim.tbl_deep_extend("force", autocmds.autoCommands, windowAutocommands)
    autocmds.setAutoCommands()
end

function M.initHighlight()
    _G.Themepicker.currentHighlightLine = -1
    _G.Themepicker.namespace = utils.getNamespaceByNameOrCreateNew("Themepicker")
end

function M.setHighlight(line)
    local pickerBuffer = utils.getBufferByName("Themepicker")

    if line >= #vim.api.nvim_buf_get_lines(pickerBuffer, 0, -1, false) then
        line = 0
    end

    if line < 0 then
        line = #vim.api.nvim_buf_get_lines(pickerBuffer, 0, -1, false) - 1
    end

    local namespace = _G.Themepicker.namespace

    vim.api.nvim_buf_clear_namespace(pickerBuffer, namespace, 0, -1)

    M.createHighlightGroups()

    vim.api.nvim_buf_set_extmark(
        pickerBuffer,
        namespace,
        line,
        0,
        {
            end_line = line + 1,
            hl_group = (vim.o.background == "dark") and "ThemepickerDark" or "ThemepickerLight",
        }
    )

    _G.Themepicker.currentHighlightLine = line
end

function M.createHighlightGroups()
    local lightArgs = (type(config.config.window.highlights.light.additional_args) == "string") and config.config.window.highlights.light.additional_args or table.concat(config.config.window.highlights.light.additional_args, " ")
    local darkArgs = (type(config.config.window.highlights.dark.additional_args) == "string") and config.config.window.highlights.dark.additional_args or table.concat(config.config.window.highlights.dark.additional_args, " ")

    vim.cmd([[highlight ThemepickerLight guifg=]] .. config.config.window.highlights.light.guifg .. [[ guibg=]] .. config.config.window.highlights.light.guibg .. [[ gui=bold]] .. lightArgs)
    vim.cmd([[highlight ThemepickerDark guifg=]] .. config.config.window.highlights.dark.guifg .. [[ guibg=]] .. config.config.window.highlights.dark.guibg .. [[ gui=bold]] .. darkArgs)
end

function M.nextSelection()
    M.setHighlight(_G.Themepicker.currentHighlightLine + 1)
end

function M.previousSelection()
    M.setHighlight(_G.Themepicker.currentHighlightLine - 1)
end

return M
