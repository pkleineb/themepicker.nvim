local M = {}

M.autoCommands = {
}

function M.setAutoCommands()
    local augroup = vim.api.nvim_create_augroup("Themepicker", { clear = true })

    for _, command in ipairs(M.autoCommands) do
        local config = vim.tbl_deep_extend("force", command.config, { group = augroup })
        vim.api.nvim_create_autocmd(
            command.event,
            config
        )
    end
end

return M
