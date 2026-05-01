return {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        "nvim-telescope/telescope-ui-select.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
        "polirritmico/telescope-lazy-plugins.nvim",
        "folke/noice.nvim",
        'ahmedkhalf/project.nvim',
        'MaximilianLloyd/ascii.nvim',
    },
    opts = function()
        local themes = require("telescope.themes")
        local actions = require("telescope.actions")
        return {
            defaults = {
                vimgrep_arguments = {
                    "rg",
                    "--with-filename",
                    "--no-heading",
                    "--color=never",
                    "--line-number",
                    "--column",
                    "--smart-case",
                }, -- TODO: Set rg settings to allign text
                path_display = { "truncate" },
                mappings = {
                    i = {
                        ["<C-V>"] = false,
                        ["<C-T>"] = false,
                        ["<CR>"] = actions.select_default,
                        ["<C-_>"] = actions.select_horizontal,
                        ["<C-L>"] = actions.select_vertical,
                        ["<C-X>"] = actions.select_tab,
                        ["<C-h>"] = "which_key",
                        ["<esc>"] = actions.close,
                        ['<C-g>'] = function(prompt_bufnr) -- TODO: TEST that this works
                            -- Use nvim-window-picker to choose the window by dynamically attaching a function
                            local action_set = require('telescope.actions.set')
                            local action_state = require('telescope.actions.state')

                            local picker = action_state.get_current_picker(prompt_bufnr)
                            picker.get_selection_window = function(picker, entry)
                                local picked_window_id = require('window-picker').pick_window() or vim.api.nvim_get_current_win()
                                -- Unbind after using so next instance of the picker acts normally
                                picker.get_selection_window = nil
                                return picked_window_id
                            end

                            return action_set.edit(prompt_bufnr, 'edit')
                        end,
                    },
                    n = {
                        ["<C-V>"] = false,
                        ["<C-T>"] = false,
                        ["<CR>"] = actions.select_default,
                        ["<C-_>"] = actions.select_horizontal,
                        ["<C-L>"] = actions.select_vertical,
                        ["<C-X>"] = actions.select_tab,
                        ["<C-h>"] = "which_key",
                    },
                },
            },
            pickers = {
                find_files = {
                    hidden = false,
                    no_ignore = false,
                },
                file_browser = {
                    -- use the "ivy" theme if you want
                    theme = "ivy",
                },
                live_grep = {
                    previewer = true,
                    layout_strategy = "center",
                    layout_config = {
                        width = 0.95,
                        height = 0.2,
                        prompt_position = "top",
                        preview_cutoff = 1,
                        mirror = false,
                        anchor = "N",
                    },
                    sorting_strategy = "ascending",
                },
                grep_string = {
                    layout_strategy = "vertical",
                },
            },
            extensions = {
                ["ui-select"] = themes.get_dropdown({}),
                lazy_plugins = {
                    lazy_config = vim.fn.stdpath("config") .."/lua/Drannor/lazy.lua", -- FIX: Issue with global vim
                },
                tele_tabby = {
                    use_highlighter = true,
                },
            },
        }
    end,
    -- TODO: FIX Window looks
    config = function(_, opts)
        local telescope = require("telescope")
        telescope.setup(opts)
        telescope.load_extension("noice")
        telescope.load_extension('fzf')
        telescope.load_extension("ui-select")
        telescope.load_extension("lazy_plugins")
        telescope.load_extension('projects')
        telescope.load_extension('file_browser')
        telescope.load_extension('ascii')
    end,
    keys = function()
        local telescope = require("telescope.builtin")
        return {
            { "<leader>ff", function() telescope.find_files() end,                                  desc = "project files" },
            { "<leader>gg", function() telescope.live_grep() end,                                   desc = "live grep" },
            { "<leader>gc", function() telescope.live_grep { cwd = vim.fn.stdpath("config") } end, desc = "live grep config files" },
            { "<leader>fh", function() telescope.help_tags() end,                                   desc = "search help" },
            { "<leader>fb",  function() telescope.buffers() end,                                     desc = "search buffers" },
            { "<leader>fdd", function() telescope.diagnostics({ bufnr = 0 }) end,                    desc = "search document diagnostics" },
            { "<leader>fds", function() telescope.lsp_document_symbols() end,                        desc = "search document symbols" },
            { "<leader>fwd", function() telescope.diagnostics() end,                                 desc = "search workspace diagnostics" },
            { "<leader>fws", function() telescope.lsp_dynamic_workspace_symbols() end,               desc = "search workspace symbols" },
            { "<leader>fc", function() telescope.find_files { cwd = vim.fn.stdpath("config") } end, desc = "nvim config files" },
            { "<leader>fp", "<cmd>Telescope lazy_plugins<cr>", desc = "plugin configs" },
            { "<leader>ft", "<cmd>Telescope colorscheme<cr>", desc = "Browse Color Schemes" },
            { "<leader>m", "<cmd>Telescope noice<cr>", desc = "Noice message history" },
            { "<leader>fe", "<cmd>Telescope file_browser<cr>", desc = "file browser" },
        }
    end,
}
