local M = {}

M.test = function()
    -- Create a new buffer
    local buf = vim.api.nvim_create_buf(false, true)

    -- Set some text in the buffer
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"Hello, World!"})

    -- Define the floating window configuration
    local width = 40
    local height = 10
    local row = 1
    local col = 1
    local border_opts = {
        relative = 'editor', -- This makes the window floating
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal', -- Optional: Set the border style
    }

    -- Open the floating window
    local win = vim.api.nvim_open_win(buf, true, border_opts)
end

return M
