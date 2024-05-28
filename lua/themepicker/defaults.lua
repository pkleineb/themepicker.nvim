return {
    keys = {
        {
            mode = "n",
            keys = "o",
            command = "<cmd>lua require'lua.themepicker.loader'.applyColorScheme()<CR>",
            opts = {
                silent = true,
                noremap = true,
            }
        },
        {
            mode = "n",
            keys = "q",
            command = "<cmd>lua require'lua.themepicker.window'.closeWindow()<CR>",
            opts = {
                silent = true,
                noremap = true,
            }
        }
    },

    themes = {
        theme_dir = vim.fn.stdpath("data")
    }
}
