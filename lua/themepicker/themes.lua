local M = {}

function M.getThemes()
    local dataPath = vim.fn.stdpath("data")
    local colorSchemePaths = vim.fn.glob(dataPath .. "**/colors/*.lua") .. "\n" .. vim.fn.glob(dataPath .. "**/colors/*.vim")

    local themes = {}
    for path in colorSchemePaths:gmatch("([^\n]*)\n?") do
        if path == "" then goto continue end
        local colorSchemeFile = path:match("([^/]+)$")
        local colorScheme = colorSchemeFile:match("(.+)%.[^.]+$")

        table.insert(themes, colorScheme)

        ::continue::
    end

    return themes
end

return M
