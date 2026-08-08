-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Save
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })

-- Quit
map("n", "<C-q>", "<cmd>q<cr>", { desc = "Quit" })
map("i", "<C-q>", "<Esc><cmd>q<cr>", { desc = "Quit" })

-- Copy to system clipboard
map("v", "<C-c>", '"+y', { desc = "Copy" })

-- Cut to system clipboard
map("v", "<C-x>", '"+d', { desc = "Cut" })

-- Paste from system clipboard
map("n", "<C-v>", '"+p', { desc = "Paste" })
map("i", "<C-v>", "<C-r>+", { desc = "Paste" })
map("v", "<C-v>", '"+p', { desc = "Paste" })

-- Select all
map("n", "<C-a>", "ggVG", { desc = "Select all" })
