return {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
    vim.lsp.config("lua_ls", {
        settings = {
            Lua = {
                diagnostics = { globals = { "vim", "require" } },
                workspace = {
                    library = {
                        vim.env.VIMRUNTIME,
                        "${3rd}/luv/library",
                        "${3rd}/busted/library",
                    },
                    checkThirdParty = false,
                },
                completion = { callSnippet = "Replace" },
            },
        },
    }),
    config = function ()
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "vimls",
                "gopls",
                "clangd"
            },
        })
    end
}
