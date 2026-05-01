return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
        ensure_installed = {
            "bash",
            "c",
            "cpp",
            "go",
            "gomod",
            "gosum",
            "gowork",
            "json",
            "html",
            "latex",
            "lua",
            "markdown",
            "markdown_inline",
            "python",
            "sql",
            "regex",
            "yaml",
            "vim",
            "vimdoc",
        },
        sync_install = false,
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true
        },
    },
}
