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
        if winBuf == buffer then
            return win
        end
    end

    return nil
end

function M.mergeConfig(baseConfig, newConfig)
    return vim.tbl_deep_extend("force", baseConfig, newConfig or {})
end

return M
