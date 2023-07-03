local keymap = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }

-- Windows and buffers
keymap("n", "<leader>wv", ":vsplit <CR>", default_opts)
keymap("n", "<leader>ws", ":split <CR>", default_opts)
keymap("n", "<leader>wd", ":q <CR>", default_opts)

keymap("n", "<leader>wl", ":wincmd l <CR>", default_opts)
keymap("n", "<leader>wh", ":wincmd h <CR>", default_opts)
keymap("n", "<leader>wk", ":wincmd k <CR>", default_opts)
keymap("n", "<leader>wj", ":wincmd j <CR>", default_opts)

keymap("n", "<leader>bp", ":bprevious <CR>", default_opts)
keymap("n", "<leader>bn", ":bnext <CR>", default_opts)
keymap("n", "<leader>bd", ":bdelete <CR>", default_opts)

-- Files
keymap("n", "<leader>fs", ":w <CR>", default_opts)
--keymap("n", "<leader>fd", ":call delete(expand('%')) | bdelete! <CR>", default_opts)


-- Fzf
keymap("n", "<leader>ff", ":FzfLua files <CR>", default_opts)
keymap("n", "<leader>/", ":FzfLua live_grep <CR>", default_opts)

-- Tree
keymap("n", "<leader>op", ":NvimTreeToggle <CR>", default_opts)
keymap("n", "<leader>oP", ":NvimTreeFindFile <CR>", default_opts)

-- Git
keymap("n", "<leader>gg", ":Neogit <CR>", default_opts)


-- Commenting
keymap("n", "<leader>c", ":CommentToggle <CR>", default_opts)
keymap("v", "<leader>c", ":'<,'>CommentToggle <CR>", default_opts)

-- Moving lines
keymap("n", "<leader>k", ":MoveLine(-1) <CR>", default_opts)
keymap("n", "<leader>j", ":MoveLine(1) <CR>", default_opts)
keymap("v", "<leader>k", ":MoveBlock(-1) <CR>", default_opts)
keymap("v", "<leader>j", ":MoveBlock(1) <CR>", default_opts)

-- TODO
-- toggle maximize window
-- <leader>fC create copy of file with new name
-- copy current filename into clipboard
-- uppercase next word
-- find files outside of project spc-.
-- live_grep search for visual selected word spc-/
-- git time machine
