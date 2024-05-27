local utils = require("lua.themepicker.utils")
local themes = require("lua.themepicker.themes")

local M = {}

function M.applyColorScheme()
    local schemePath, schemeName, moduleType = unpack(M.getColorSchemeUnderCursor())

    M.loadColorScheme(schemePath, schemeName, moduleType)
end

function M.getColorSchemeUnderCursor()
    local buffer = utils.getBufferByName("Themepicker")
    if not buffer then error("Couldnt retrieve the right buffer. Try restarting vim") end

    local win = utils.getWinByBuffer(buffer)
    if not win then error("Couldnt retrieve the right window. Try restarting vim") end

    local row, _ = unpack(vim.api.nvim_win_get_cursor(win))

    local theme = vim.api.nvim_buf_get_lines(buffer, row - 1, row, false)[1]
    local escapedTheme = theme:gsub("%-", "%%-")

    local colorSchemePaths = themes.getColorSchemePaths()

    local colorSchemePath = ""
    local moduleType = ""
    for _, path in ipairs(colorSchemePaths) do
        if path:match(".+" .. escapedTheme .. ".+") then
            moduleType = path:match("([^/]+)$")
            moduleType = moduleType:match("[^.]+%.(.+)$")
            colorSchemePath = path:gsub("colors.*$", "colors/")
            break
        end
    end

    return { colorSchemePath, theme, moduleType }
end

function M.loadColorScheme(modulePath, moduleName, moduleType)
    --vim.opt.rtp:append(modulePath)

    if moduleType == "lua" then
        local pattern = "(/[^/]*)(/[^/]*)$"
        local luaPath = modulePath:gsub(pattern, "")
        vim.opt.rtp:append(luaPath)
    end

    vim.cmd("source " .. modulePath .. moduleName .. "." .. moduleType)

    vim.cmd("colorscheme " .. moduleName)
end

function M.setup(config)
    M.config = config
end

return M
