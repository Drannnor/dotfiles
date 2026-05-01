return {
    "olimorris/onedarkpro.nvim",
    priority = 1000,
    config = function(_, opts)
        require('onedarkpro').setup(opts)
        vim.cmd.colorscheme("onedark_vivid")
    end,
    opts = {
        options = {
            cursorline = true, -- Use cursorline highlighting?
            transparency = false, -- Use a transparent background?
            terminal_colors = true, -- Use the theme's colors for Neovim's :terminal?
            lualine_transparency = false, -- Center bar transparency?
        },
        styles = {
            keywords = "bold",
            functions = "bold",
            methods = "bold",
            types = "bold",
            parameters = "italic",
        },
        highlights = {
            ["@keyword.go"] = { fg = "#ff9e64", bold = true },
            ["@type.go"] = { fg = "#7aa2f7", bold = true },
            ["@function.go"] = { fg = "#9ece6a", bold = true },
            ["@function.method.go"] = { fg = "#73daca", bold = true },
            ["@variable.parameter.go"] = { fg = "#e0af68", italic = true },
            ["@property.go"] = { fg = "#c0caf5" },
        },
    }
}
