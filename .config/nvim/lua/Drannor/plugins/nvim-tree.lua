return {
    "nvim-tree/nvim-tree.lua",
    keys = {
        { "<leader>n", vim.cmd.NvimTreeFindFileToggle, desc = "Toggle file tree" },
    },
    opts = {
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
            enable = true,
            update_root = true
        },
    },
    config = function(_, opts)
        require("nvim-tree").setup(opts)
    end
}
