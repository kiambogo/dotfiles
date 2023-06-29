---@type MappingsTable
local M = {}

M.general = {
  n = {
    ["<leader>;"] = { ":", "enter command mode", opts = { nowait = true } },


    ["<leader>fs"] = { "<cmd> w <CR>", "Save file" },
    -- ["<leader>w"] = { "<cmd> q <CR>", "Close window" },

    -- Windows + buffers
    ["<leader>wv"] = { "<cmd> vsplit <CR>", "Split vertically" },
    ["<leader>ws"] = { "<cmd> split <CR>", "Split horizontally" },

    ["<leader>wh"] = { "<cmd> wincmd h <CR>", "Focus west window" },
    ["<leader>wl"] = { "<cmd> wincmd l <CR>", "Focus east window" },
    ["<leader>wj"] = { "<cmd> wincmd j <CR>", "Focus south window" },
    ["<leader>wk"] = { "<cmd> wincmd k <CR>", "Focus north window" },

    -- Files
    ["<leader>fg"] = { "<cmd> Telescope live_grep <CR>", "Live grep" },

  },
}

M.neogit = {
  n = {
    ["<leader>gg"] = {"<cmd> Neogit <CR>", "Git status"}
  }
}

return M
