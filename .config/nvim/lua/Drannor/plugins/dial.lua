return {
    "monaqa/dial.nvim",
    -- stylua: ignore
    keys = {
        { "<C-PageUp>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
        { "<C-PageDown>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
    },
    config = function()
        local augend = require("dial.augend")
        require("dial.config").augends:register_group({
            default = {
                augend.integer.alias.decimal,
                augend.integer.alias.hex,
                augend.date.alias["%Y/%m/%d"],
                augend.constant.alias.bool,
                augend.constant.new({ elements = { "let", "const" } }),
                augend.constant.new({
                    elements = { "'", '"' },
                    word = false,
                    cyclic = true,
                }),
            },
        })
    end,
}
