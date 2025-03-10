# Themepicker.nvim
A super basic themepicker plugin that supports lazy loading colorschemes and a bit of customization

## Installation
### With lazy.nvim
```lua
return {
    "pkleineb/themepicker.nvim",
    -- important to keep your colorscheme between nvim sessions
    lazy = false,
    
    config = function
        require("themepicker").setup({opts})
    end
}
```

### Configuration
On calling setup you can pass in a lua table of options.
The defaults are listed below:
```lua
{
    keys = {
        {
            -- can be table or string of valid vim modes
            mode = {
                "i",
                "n",
            },
            keys = "<CR>",
            command = "<cmd>lua require'themepicker.loader'.apply_color_scheme()<CR>",
            opts = {
                silent = true,
                noremap = true,
            }
        },
        {
            -- can be table or string of valid vim modes
            mode = "i",
            keys = "<C-c>",
            command = "<cmd>lua require'themepicker.window'.close_window()<CR>",
            opts = {
                silent = true,
                noremap = true,
            }
        },
        {
            -- can be table or string of valid vim modes
            mode = "n",
            keys = "<Esc>",
            command = "<cmd>lua require'themepicker.window'.close_window()<CR>",
            opts = {
                silent = true,
                noremap = true,
            }
        },
        {
            -- can be table or string of valid vim modes
            mode = {
                "i",
                "n",
            },
            keys = "<Tab>",
            command = "<cmd> lua require'themepicker.window'.next_selection()<CR>",
            opts = {
                silent = true,
                noremap = true,
            }
        },
        {
            -- can be table or string of valid vim modes
            mode = {
                "i",
                "n",
            },
            keys = "<S-Tab>",
            command = "<cmd> lua require'themepicker.window'.previous_selection()<CR>",
            opts = {
                silent = true,
                noremap = true,
            }
        },

    },

    themes = {
        -- dir where colorschemes get downloaded to from plugin manager or where to look for colorschemes
        -- scans all child dirs as well
        -- either string or table of strings
        theme_dir = vim.fn.stdpath("data")

        -- exclude certain colorschemes that have these patterns in their path
        -- table of strings
        exclude_themes = {"example"},

        -- enables or disables persitent themes
        -- bool
        persistent_theme_enable = true,
        
        -- time in miliseconds when to reapply theme after startup in seconds(if this is 0 webdevicons on nvim tree wont get colored)
        -- unsigned int in miliseconds
        persistent_theme_timeout = 50,

        -- where themepicker.nvim places the file to store colorscheme in between neovim sessions
        -- path string
        save_theme_dir = vim.fn.stdpath("data"),
    },

    window = {
        style = "minimal",
        relative = "editor",
        border = "rounded",
        -- width and height as float from 0-1 as percentual size of vim window
        total_width = 0.4,
        total_height = 0.4,

        searchbar = {
            -- either int or float(0-1) 
            -- if int amount of lines 
            -- if float percentual size of total_height
            height = 1,
            padding = 0,
            -- determines start of search bar " " gets appended to front and back
            search_decorator = ">",
        },

        highlights = {
            light = {
                guifg = "white",
                guibg = "#adc4ff",
                -- can be either lua table or string of args if table seperates args using " "
                -- all arguments for highlight vim command are allowed :h hi
                additional_args = {
                }
            },
            dark = {
                guifg = "black",
                guibg = "#7090ff",
                -- can be either lua table or string of args if table seperates args using " "
                -- all arguments for highlight vim command are allowed :h hi
                additional_args = {
                }
            }
        }
    },
}
```
