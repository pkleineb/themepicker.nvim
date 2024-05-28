local M = {}

function M.getBufferByName(name)
    local buffers = vim.api.nvim_list_bufs()
    for _, buffer in ipairs(buffers) do
        local bufferPath = vim.api.nvim_buf_get_name(buffer)
        local bufferName = bufferPath:match("([^/]+)$")
        if bufferName == name then return buffer end
    end
    return nil
end

function M.getWinByBuffer(buffer)
    local windows = vim.api.nvim_list_wins()
    for _, win in ipairs(windows) do
        local winBuf = vim.api.nvim_win_get_buf(win)
        if winBuf == buffer then return win
        end
    end

    return nil
end

function M.mergeConfig(baseConfig, newConfig)
    return vim.tbl_deep_extend("force", baseConfig, newConfig or {})
end

function M.diffTableKeys(startTable, endTable)
    local diffTable = {}

    for key, _ in pairs(endTable) do
        if startTable[key] == nil then
            table.insert(diffTable, key)
        end
    end

    return diffTable
end

function M.parseStringTable(str)
    -- striping all the values gone
    local formattedStr = "return "
    str = str:gsub("<1>", "")
    for line in str:gmatch("[^\r\n]+") do
        line = line:gsub("=.+$", "= '',")
        formattedStr = formattedStr .. line .. "\n"
    end

    return loadstring(formattedStr)()
end

return M
