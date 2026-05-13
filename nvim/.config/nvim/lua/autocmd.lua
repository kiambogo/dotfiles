-- General
-- Clear trailing whitespace on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

-- Open nvim-tree when launched with a directory argument
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function(data)
		if vim.fn.isdirectory(data.file) == 1 then
			require("nvim-tree.api").tree.open()
		end
	end,
})

-- Go support
--
-- Run goimports on save
vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("GoImports", {clear = true}),
	pattern = "*.go",
	command = "silent! GoImports",
})
-- Run gofmt on save
vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("GoFmt", {clear = true}),
	pattern = "*.go",
	command = "silent! GoFmt",
})
