local window = require("lua.themepicker.window")

local M = {}

M.commands = {
    {
        name = "Test",
        command = function()
            window.renderWindow()
        end,
        options = {},
    },
}

function M.setup()
    for _, command in ipairs(M.commands) do
        local options = vim.tbl_extend("force", command.options, { force = true })
        vim.api.nvim_create_user_command(command.name, command.command, options)
    end
end

return M
