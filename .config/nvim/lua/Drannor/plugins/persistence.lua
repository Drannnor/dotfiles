return {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
        -- add any custom options here
    },
    config = function (_,opts)
        require("persistence").setup(opts)
    end,
    keys = function ()
        local persistence = require("persistence")
        return {
            { "<leader>qs", function() persistence.load() end, desc = "Load current directory Session" },
            { "<leader>qS", function() persistence.select() end, desc = "Select Session" },
            { "<leader>ql", function() persistence.load({ last = true }) end, desc = "Load Last Session" },
            { "<leader>qd", function() persistence.stop() end, desc = "Stop persistence" }
        }
    end
}
