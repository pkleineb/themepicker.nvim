local utils = require("themepicker.utils")
local themes = require("themepicker.themes")
local window = require("themepicker.window")

local M = {}

function M.applyColorScheme()
    local pickerBuffer = utils.getBufferByName("Themepicker")
    if #vim.api.nvim_buf_get_lines(pickerBuffer, 0, -1, false) == 1 and vim.api.nvim_buf_get_lines(pickerBuffer, 0, -1, false)[1] == "" then return end

    local schemePath, schemeName, moduleType = unpack(M.getColorSchemeUnderSelection())

    M.loadColorScheme(schemePath, schemeName, moduleType)
end

function M.getColorSchemeUnderSelection()
    local pickerBuffer = utils.getBufferByName("Themepicker")
    if not pickerBuffer then error("Couldnt retrieve the right pickerBuffer. Try restarting vim") end

    local win = utils.getWinByBuffer(pickerBuffer)
    if not win then error("Couldnt retrieve the right window. Try restarting vim") end

    local row = _G.Themepicker.currentHighlightLine

    local theme = vim.api.nvim_buf_get_lines(pickerBuffer, 0, -1, false)[row + 1]
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
    local pattern = "(/[^/]*)(/[^/]*)$"
    local pluginPath = modulePath:gsub(pattern, "")
    vim.opt.rtp:append(pluginPath)

    local beforeLoadPackages = utils.parseStringTable(vim.inspect(package.loaded, { depth = 1 }))

    vim.cmd("source " .. modulePath .. moduleName .. "." .. moduleType)
    vim.cmd("colorscheme " .. moduleName)

    local afterLoadPackages = utils.parseStringTable(vim.inspect(package.loaded, { depth = 1 }))

    local newLoadedPlugins = utils.diffTableKeys(beforeLoadPackages, afterLoadPackages)

    if vim.g.activeTheme ~= nil then
        vim.opt.rtp:remove(vim.g.activeTheme.pluginPath)
        for _, plugin in ipairs(vim.g.activeTheme.loadedPlugins) do
            package.loaded[plugin] = nil
        end
    end

    vim.g.activeTheme = {
        pluginPath = pluginPath,
        loadedPlugins = newLoadedPlugins,
    }

    window.setHighlight(_G.Themepicker.currentHighlightLine)
end

return M
