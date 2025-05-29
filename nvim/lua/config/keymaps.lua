-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map('n', ';', ':')
map('i', 'jk', '<Esc>')
map('n', '<leader>oo', 'o<Esc>', { desc = "Insert a new line below"})
