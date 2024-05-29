return {
    keys = {
        {
            mode = "n",
            keys = "<CR>",
            command = "<cmd>lua require'lua.themepicker.loader'.applyColorScheme()<CR>",
            opts = {
                silent = true,
                noremap = true,
            }
        },
        {
            mode = "i",
            keys = "<C-c>",
            command = "<cmd>lua require'lua.themepicker.window'.closeWindow()<CR>",
            opts = {
                silent = true,
                noremap = true,
            }
        },
        {
            mode = "n",
            keys = "<Esc>",
            command = "<cmd>lua require'lua.themepicker.window'.closeWindow()<CR>",
            opts = {
                silent = true,
                noremap = true,
            }
        }
    },

    themes = {
        theme_dir = vim.fn.stdpath("data")
    },

    window = {
        style = "minimal",
        relative = "editor",
        border = "rounded",
        total_width = 0.8,
        total_height = 0.8,

        searchbar = {
            height = 1,
            padding = 0,
            search_decorator = ">",
        },
    },
}
