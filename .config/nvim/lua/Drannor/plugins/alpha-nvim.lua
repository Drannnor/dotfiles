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
        -- mytheme.file_icons.provider = "devicons"
        -- mytheme.section.header.opts = {
        --     position = "center"
        -- }
        -- mytheme.section.footer.opts = {
        --     position = "center"
        -- }
        -- print(vim.inspect(mytheme.buttons))
        mytheme.header.val = ascii.art.text.neovim.sharp
        require("alpha").setup(mytheme.config)
    end,
}
