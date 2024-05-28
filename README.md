# Themepicker.nvim
A super basic themepicker plugin

## Installation
### With lazy.nvim
```lua
return {
    "pkleineb/themepicker.nvim",
    
    config = function
        require("themepicker.nvim").setup({opts})
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
            mode = "n",
            keys = "o",
            command = "<cmd>lua require'themepicker.loader'.applyColorScheme()<CR>",
            opts = {
                silent = true,
                noremap = true,
            }
        },
        {
            mode = "n",
            keys = "q",
            command = "<cmd>lua require'themepicker.window'.closeWindow()<CR>",
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
```
