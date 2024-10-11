local config = require("themepicker.config")

local M = {}

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

function M.get_color_scheme_paths()
    local data_path = config.config.themes.theme_dir
    local color_scheme_paths = {}

    if type(data_path) == "table" then
        for _, path in ipairs(data_path) do
            vim.list_extend(color_scheme_paths, M.process_path(path))
        end
    else
        color_scheme_paths = M.process_path(data_path)
    end

    return color_scheme_paths
end

function M.process_path(path)
    local plugin_paths = vim.fs.find(
        {".git"},
        {limit = math.huge, type = "directory", path = path}
    )
    local color_scheme_paths = {}
    for _, path in ipairs(plugin_paths) do
        -- grabbing the parent_dir to look through the plugin dir and to have a reference to the base path
        -- of the colorscheme
        local parent_dir = vim.fs.dirname(path)

        -- grabbing all the colorscheme files(lua and vim files that are in a /colors/ directory)
        -- paths get normalized by find
        local color_paths = M.find_color_files(parent_dir)

        if #color_paths == 0 then goto continue end

        local escaped_parent_dir = parent_dir:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
        local pattern = escaped_parent_dir .. "(.*)$"

        local path_buffer = {}
        local min_depth = math.huge
        for _, color_scheme in ipairs(color_paths) do
            local color_scheme_src_path = color_scheme:match(pattern)
            local depth = M.get_path_depth(color_scheme_src_path)

            if depth < min_depth then
                min_depth = depth
                -- clear path_buffer since all paths put in there before must have been deeper then this
                -- path
                path_buffer = {}
            end

            -- this should also trigger when a new min_depth got found because we set min_depth to depth
            if depth == min_depth then
                table.insert(path_buffer, color_scheme)
            end
        end

        vim.list_extend(color_scheme_paths, path_buffer)

        ::continue::
    end

    return color_scheme_paths
end

function M.find_color_files(parent_dir)
    return vim.fs.find(function(name, path)
        local is_valid_file = name:match(".*%.lua$") or name:match(".*%.vim$")

        local is_in_colors_dir = path:match("[/\\\\]colors$")

        local is_excluded = M.is_excluded(path)

        return is_valid_file and is_in_colors_dir and not is_excluded
    end,
    {limit = math.huge, type = "file", path = parent_dir}
    )

end

function M.is_excluded(path)
    for _, pattern in ipairs(config.config.themes.exclude_themes) do
        if path:match(pattern) then
            return true
        end
    end

    return false
end

function M.get_path_depth(path)
    return select(2, path:gsub("/", "")) - 1
end


return M
