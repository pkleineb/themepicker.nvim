local utils = require("lua.themepicker.utils")
local themes = require("lua.themepicker.themes")

local M = {}

function M.applyColorScheme()
    local schemePath, schemeName, moduleType = unpack(M.getColorSchemeUnderSelection())

    M.loadColorScheme(schemePath, schemeName, moduleType)
end

function M.getColorSchemeUnderSelection()
    local buffer = utils.getBufferByName("Themepicker")
    if not buffer then error("Couldnt retrieve the right buffer. Try restarting vim") end

    local win = utils.getWinByBuffer(buffer)
    if not win then error("Couldnt retrieve the right window. Try restarting vim") end

    local row = _G.Themepicker.currentHighlightLine

    local theme = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)[row + 1]
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
end

function M.setup(config)
    M.config = config
end

return M
