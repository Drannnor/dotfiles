-- Nvim Keymaps
vim.g.mapleader = " "

local map = vim.keymap.set

-- Run lua selection
map("v", "<leader>rl", ":'<,'>lua<CR>", { desc = "Run lua selection" })

-- Run current lua file
map("n", "<leader>rl", "<cmd>.lua<CR>", { desc = "Run current lua file" })

-- Source current file
map("n", "<leader>rs", "<cmd>write<CR><cmd>source %<CR>", { desc = "Source current file" })

-- Save and run the current script
map("n", "<leader>rr", "<cmd>write<CR><cmd>!./%<CR>", { desc = "Save and run current file" })

-- Run chmod +x on current file to make it executable
map("n", "<leader>rx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make current file executable" })

-- Start file-wide substitute for word under cursor; cursor ends near flags for quick edits
map( "n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute word under cursor in file" })

-- Start file-wide substitute for word under cursor; cursor ends near flags for quick edits
map("v", "<leader>s", [["sy:%s/\V<C-r>=escape(@s, '/\')<CR>/<C-r>=escape(@s, '/\')<CR>/gI<Left><Left><Left>]], { desc = "Substitute visual selection in file"})

-- Move selected block one line down, keep it selected, then reindent
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })

-- Move selected block one line up, keep it selected, then reindent
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Join current line with next line while preserving cursor/view position
map("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Scroll half page down and recenter cursor line
map("n", "<C-d>", "<C-d>zz", { desc = "Half-page down and center cursor" })

-- Scroll half page up and recenter cursor line
map("n", "<C-u>", "<C-u>zz", { desc = "Half-page up and center cursor" })

-- Jump to next search result, recenter, and open folds if needed
map("n", "n", "nzzzv", { desc = "Next search result centered" })

-- Jump to previous search result, recenter, and open folds if needed
map("n", "N", "Nzzzv", { desc = "Previous search result centered" })

-- Paste over visual selection without overwriting your last yank
map("x", "<leader>p", '"_dP', { desc = "Paste over selection without replacing yank" })

-- Delete text without copying it into registers (black-hole register)
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })
