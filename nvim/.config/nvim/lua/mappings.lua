-- Tabs
vim.keymap.set("n", "<leader>tt", ":tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "<leader>tT", ":tab split<CR>", { desc = "Tab split" })
vim.keymap.set("n", "<leader>tn", ":tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>tp", ":tabprev<CR>", { desc = "Previous tab" })
vim.keymap.set("n", "<leader>td", ":tabclose<CR>", { desc = "Close tab" })
vim.keymap.set("n", "<leader>tO", ":tabonly<CR>", { desc = "Close other tabs" })

-- Windows
vim.keymap.set("n", "<leader>wv", ":vsplit<CR>", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>ws", ":split<CR>", { desc = "Horizontal split" })
vim.keymap.set("n", "<leader>wd", ":q<CR>", { desc = "Close window" })
vim.keymap.set("n", "<leader>wl", ":wincmd l<CR>", { desc = "Window right" })
vim.keymap.set("n", "<leader>wh", ":wincmd h<CR>", { desc = "Window left" })
vim.keymap.set("n", "<leader>wk", ":wincmd k<CR>", { desc = "Window up" })
vim.keymap.set("n", "<leader>wj", ":wincmd j<CR>", { desc = "Window down" })

-- Buffers
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- Files
vim.keymap.set("n", "<leader>fs", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>fD", ":call delete(expand('%')) | bdelete!<CR>", { desc = "Delete file" })
vim.keymap.set("n", "<leader>fy", ":let @+ = expand('%t')<CR>", { desc = "Yank filename" })
vim.keymap.set("n", "<leader>gh", ":OpenInGHFile<CR>", { desc = "Open in GitHub" })
vim.keymap.set("v", "<leader>gh", ":OpenInGHFileLines<CR>", { desc = "Open lines in GitHub" })

-- Fzf
vim.keymap.set("n", "<leader>ff", ":FzfLua files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>pf", ":FzfLua git_files<CR>", { desc = "Find git files" })
vim.keymap.set("n", "<leader>/", ":FzfLua live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>.", function()
	local current_file_dir = vim.fn.expand('%:p:h')
	require('fzf-lua').files({ cwd = current_file_dir })
end, { desc = "Find files from current directory" })

-- Tree
vim.keymap.set("n", "<leader>op", ":NvimTreeToggle<CR>", { desc = "Toggle file tree" })
vim.keymap.set("n", "<leader>oP", ":NvimTreeFindFile<CR>", { desc = "Find file in tree" })

-- Git
vim.keymap.set("n", "<leader>gg", ":Neogit<CR>", { desc = "Open Neogit" })

-- Commenting
vim.keymap.set("n", "<leader>c", ":CommentToggle<CR>", { desc = "Toggle comment" })
vim.keymap.set("v", "<leader>c", ":'<,'>CommentToggle<CR>", { desc = "Toggle comment" })

-- Moving lines
vim.keymap.set("n", "<leader>k", ":MoveLine(-1)<CR>", { desc = "Move line up" })
vim.keymap.set("n", "<leader>j", ":MoveLine(1)<CR>", { desc = "Move line down" })
vim.keymap.set("v", "<leader>k", ":MoveBlock(-1)<CR>", { desc = "Move block up" })
vim.keymap.set("v", "<leader>j", ":MoveBlock(1)<CR>", { desc = "Move block down" })


-- Bazel
vim.keymap.set("n", "<leader>mb", function()
	require("bazel").build_current_target()
end, { noremap = true, silent = true, desc = "Build Bazel target at cursor" })

vim.keymap.set("n", "<leader>mt", function()
	require("bazel").test_current_target()
end, { noremap = true, silent = true, desc = "Test Bazel target at cursor" })


-- Reload config
vim.keymap.set("n", "<leader>rr", function()
	-- Clear loaded Lua modules
	for name, _ in pairs(package.loaded) do
		if name:match('^bazel') or name:match('^plugins') or name:match('^mappings') or name:match('^autocmd') then
			package.loaded[name] = nil
		end
	end
	-- Reload init.lua
	dofile(vim.env.MYVIMRC)
	print("Config reloaded!")
end, { noremap = true, silent = false, desc = "Reload Neovim config" })

-- TODO
-- <leader>fC create copy of file with new name
-- uppercase next word
-- find files outside of project spc-.
-- live_grep search for visual selected word spc-/
-- git time machine
-- open commit in browser
-- resizing of windows
-- functions for running compilation/bazel
-- scratchpad
