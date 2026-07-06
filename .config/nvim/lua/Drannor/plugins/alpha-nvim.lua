return {
    "goolord/alpha-nvim",
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        'nvim-mini/mini.icons',
        'MaximilianLloyd/ascii.nvim',
    },
    config = function()
        local mytheme = require("alpha.themes.theta")
        local ascii = require("ascii")
        mytheme.header.val = ascii.art.text.neovim.sharp
        require("alpha").setup(mytheme.config)
        vim.keymap.set("n", "<leader>h", "<cmd>Alpha<cr>", { desc = "Open Alpha home" })
    end,
}
