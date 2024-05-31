local config = require("lua.themepicker.config")

local M = {}

function M.getColorSchemePaths()
    local dataPath = config.config.themes.theme_dir
    local colorSchemePathString = ""
    if type(dataPath) == "table" then
        colorSchemePathString = ""
        for _, path in ipairs(dataPath) do
            colorSchemePathString = colorSchemePathString .. "\n" .. vim.fn.glob(path .. "**/colors/*.lua") .. "\n" .. vim.fn.glob(path .. "**/colors/*.vim")
        end
    else
        colorSchemePathString = vim.fn.glob(dataPath .. "**/colors/*.lua") .. "\n" .. vim.fn.glob(dataPath .. "**/colors/*.vim")
    end

    local colorSchemePaths = {}
    for path in colorSchemePathString:gmatch("([^\n]*)\n?") do
        table.insert(colorSchemePaths, path)
    end

    return colorSchemePaths
end

function M.getThemes()
    local colorSchemePaths = M.getColorSchemePaths()

    local themes = {}
    for _, path in ipairs(colorSchemePaths) do
        if path == "" then goto continue end
        local colorSchemeFile = path:match("([^/]+)$")
        local colorScheme = colorSchemeFile:match("(.+)%.[^.]+$")

        table.insert(themes, colorScheme)

        ::continue::
    end

    return themes
end

return M
