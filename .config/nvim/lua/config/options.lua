-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- Mouse everywhere
opt.mouse = "a"

-- System clipboard
opt.clipboard = "unnamedplus"

-- Line numbers
opt.number = true
opt.relativenumber = false

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- UI
opt.termguicolors = true
opt.cursorline = true
opt.scrolloff = 5

-- Search
opt.ignorecase = true
opt.smartcase = true
