-- General
-- Clear trailing whitespace on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
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
