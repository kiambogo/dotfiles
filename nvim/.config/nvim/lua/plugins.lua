local plugins = {
	{
		"TimUntersberger/neogit" 
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
		"neovim/nvim-lspconfig",
		config = function()
			require("lsp")
		end,
	},
	{
		"williamboman/mason.nvim",
		lazy=false,
		build = ":MasonUpdate",
		ensure_installed = { 
			"goimports",
			"gofumpt",
			"golangci-lint",
			"gopls",
			"lua_ls",
			"rust_analyzer",
		},
		opts = {},

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
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { 'nvim-lua/plenary.nvim' },
	},
	{
		"junegunn/fzf",
		build = "./install --bin" 
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("fzf-lua").setup({})
		end
	},
	{
		"christoomey/vim-tmux-navigator",
	},

}


require("lazy").setup(plugins, {lazy=true})
