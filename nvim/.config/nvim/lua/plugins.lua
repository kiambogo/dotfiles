local plugins = {
	{
		"TimUntersberger/neogit" 
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { 'nvim-lua/plenary.nvim' },
	},
	{
		'rmehri01/onenord.nvim',
		lazy = false,
		config = function()
			vim.cmd([[colorscheme onenord]])
		end,
	},
	{
		'nvim-treesitter/nvim-treesitter',
		build = ":TSUpdate",
		ensure_installed = {"go", "lua"},
		auto_innstall = true,
		highlight = {
			enable = true,
		},
	},
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		opts = {},
	},
	{ 
		"lukas-reineke/indent-blankline.nvim",
	},
	{
		"nvim-tree/nvim-tree.lua",
		lazy = false,
		opts = {},
	},
	{
		"tpope/vim-surround",
		lazy = false,
	},
	
}


require("lazy").setup(plugins, {lazy=true})
