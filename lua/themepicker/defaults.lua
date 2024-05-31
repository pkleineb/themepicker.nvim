return {
    keys = {
        {
            mode = {
                "i",
                "n",
            },
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
        },
        {
            mode = {
                "i",
                "n",
            },
            keys = "<Tab>",
            command = "<cmd> lua require'lua.themepicker.window'.nextSelection()<CR>",
            opts = {
                silent = true,
                noremap = true,
            }
        },
        {
            mode = {
                "i",
                "n",
            },
            keys = "<S-Tab>",
            command = "<cmd> lua require'lua.themepicker.window'.previousSelection()<CR>",
            opts = {
                silent = true,
                noremap = true,
            }
        },

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

        highlights = {
            light = {
                guifg = "white",
                guibg = "#adc4ff",
                -- can be either lua table or string of args if table seperates args using " "
                -- all arguments for highlight vim command are allowed
                additional_args = {
                }
            },
            dark = {
                guifg = "black",
                guibg = "#7090ff",
                -- can be either lua table or string of args if table seperates args using " "
                -- all arguments for highlight vim command are allowed
                additional_args = {
                }
            }
        }
    },
}
