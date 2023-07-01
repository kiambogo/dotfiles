local custom_init_path = vim.api.nvim_get_runtime_file("lua/init.lua", false)[1]
if custom_init_path then
  dofile(custom_init_path)
end
