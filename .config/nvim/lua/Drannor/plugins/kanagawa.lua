return {
    "rebelot/kanagawa.nvim",
    config = function(_, opts)
        require('kanagawa').setup(opts)
        -- vim.cmd.colorscheme('kanagawa')
        -- vim.api.nvim_set_hl(0, "Whitespace", { fg = "#5c6370" })
        -- vim.api.nvim_set_hl(0, "NonText", { fg = "#5c6370" })
        -- vim.api.nvim_set_hl(0, "SpecialKey", { fg = "#5c6370" })
    end,
    opts = {
        transparent = true,
    }
}
