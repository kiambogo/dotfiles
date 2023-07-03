vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("GoImports", {clear = true}),
	pattern = "*.go",
	command = "silent! GoImports",
})
vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("GoFmt", {clear = true}),
	pattern = "*.go",
	command = "silent! GoFmt",
})
