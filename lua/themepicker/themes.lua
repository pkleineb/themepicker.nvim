local config = require("themepicker.config")

local M = {}

function M.get_color_scheme_paths()
    local data_path = config.config.themes.theme_dir
    local color_scheme_path_string = ""
    if type(data_path) == "table" then
        color_scheme_path_string = ""
        for _, path in ipairs(data_path) do
            color_scheme_path_string = color_scheme_path_string .. "\n" .. vim.fn.glob(path .. "**/colors/*.lua") .. "\n" .. vim.fn.glob(path .. "**/colors/*.vim")
        end
    else
        color_scheme_path_string = vim.fn.glob(data_path .. "**/colors/*.lua") .. "\n" .. vim.fn.glob(data_path .. "**/colors/*.vim")
    end

    local color_scheme_paths = {}
    for path in color_scheme_path_string:gmatch("([^\n]*)\n?") do
        table.insert(color_scheme_paths, path)
    end

    return color_scheme_paths
end

function M.get_themes()
    local color_scheme_paths = M.get_color_scheme_paths()

    local themes = {}
    for _, path in ipairs(color_scheme_paths) do
        if path == "" then goto continue end
        local color_scheme_file = path:match("([^/]+)$")
        local color_scheme = color_scheme_file:match("(.+)%.[^.]+$")

        table.insert(themes, color_scheme)

        ::continue::
    end

    return themes
end

return M
