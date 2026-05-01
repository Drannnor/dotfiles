return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true;
    config = function(_, opts)
        require('catppuccin').setup(opts)
    end,
    opts = {
        flavour = "auto", -- latte, frappe, macchiato, mocha
        transparent_background = true, -- disables setting the background color.
        integrations = {
            cmp = true,
            gitsigns = true,
            nvimtree = true,
            notify = false,
            mini = {
                enabled = true,
                indentscope_color = "",
            },
        },
    },
}
