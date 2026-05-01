return {
    "nvim-lualine/lualine.nvim",
    deendencies = {
        "nvim-tree/nvim-web-devicons",
        "folke/noice.nvim",
    },
    opts = {
        options = {
            icons_enabled = true,
            theme = 'ayu_dark'
        },
        sections = {
            lualine_a = {
                {
                    "filename",
                    path = 1,
                }
            },
            lualine_x = {
                {
                    require("lazy.status").updates,
                    cond = require("lazy.status").has_updates,
                    color = { fg = "#ff9e64" },
                },
                {
                    require("noice").api.status.message.get_hl,
                    cond = require("noice").api.status.message.has,
                },
                {
                    require("noice").api.status.command.get,
                    cond = require("noice").api.status.command.has,
                    color = { fg = "#ff9e64" },
                },
                {
                    require("noice").api.status.mode.get,
                    cond = require("noice").api.status.mode.has,
                    color = { fg = "#ff9e64" },
                },
                {
                    require("noice").api.status.search.get,
                    cond = require("noice").api.status.search.has,
                    color = { fg = "#ff9e64" },
                },
            },
        },
    }
}
