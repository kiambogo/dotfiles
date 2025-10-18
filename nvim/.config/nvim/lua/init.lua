vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true
vim.opt.clipboard = "unnamed"
vim.opt.number = true
vim.opt.listchars = {tab = '→ ', trail = '·', extends = '»', precedes = '«'}
vim.opt.list = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 500 -- Faster hover popup (default 4000ms)

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

-- Configure LSP diagnostics display
vim.diagnostic.config({
  virtual_text = {
    prefix = '●',  -- Could also use '■', '▎', etc.
    spacing = 4,
  },
  signs = true,
  underline = true,
  update_in_insert = false,  -- Don't update diagnostics while typing
  severity_sort = true,      -- Show errors before warnings
  float = {
    border = 'rounded',
    source = 'always',       -- Show source (e.g., "gopls")
    header = '',
    prefix = '',
  },
})

-- Customize diagnostic signs in the gutter
local signs = { Error = "✘", Warn = "▲", Hint = "⚑", Info = "»" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local lsp_zero = require('lsp-zero')

-- Default keybindings for LSP
lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({buffer = bufnr})

  -- Custom LSP keybindings
  vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, {buffer = bufnr, desc = 'Go to definition'})
  vim.keymap.set('n', '<leader>gD', function()
    vim.cmd('rightbelow vsplit')
    vim.lsp.buf.definition()
  end, {buffer = bufnr, desc = 'Go to definition in vertical split'})
  vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, {buffer = bufnr, desc = 'Find references'})
  vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, {buffer = bufnr, desc = 'Go to implementation'})

  -- Show diagnostics on hover (when cursor is on the line)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, {buffer = bufnr, desc = 'Show hover information'})
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {buffer = bufnr, desc = 'Show diagnostic in float'})

  -- Navigate between diagnostics
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {buffer = bufnr, desc = 'Go to previous diagnostic'})
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {buffer = bufnr, desc = 'Go to next diagnostic'})

  -- Auto-show diagnostic popup when hovering over a line with diagnostics
  vim.api.nvim_create_autocmd('CursorHold', {
    buffer = bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = 'rounded',
        source = 'always',
        prefix = ' ',
        scope = 'cursor',
      }
      vim.diagnostic.open_float(nil, opts)
    end
  })
end)

require("autocmd")
