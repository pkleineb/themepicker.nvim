return {
    test = true,

    keys = {
        {
            mode = "n",
            keys = "o",
            command = "<cmd>lua require'lua.themepicker.loader'.applyColorScheme()<CR>",
            opts = {
                silent = true,
                noremap = true,
            }
        }
    },
}
