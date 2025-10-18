vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

vim.api.nvim_set_option("clipboard","unnamed")
vim.wo.number = true -- line numbering
vim.opt.listchars = {tab = '→ ', trail = '·', extends = '»', precedes = '«'}
vim.opt.list = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.g.mapleader = " "


-- Install Lazy plugin manager if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- Load other lazy plugins and keymappings
require("mappings")
require("plugins")

vim.cmd.colorscheme "edge"

local lsp_zero = require('lsp-zero')

-- Default keybindings for LSP
lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({buffer = bufnr})
end)

require("autocmd")
