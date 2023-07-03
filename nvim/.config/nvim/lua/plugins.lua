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
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
		dependencies = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},             -- Required
			{                                      -- Optional
			'williamboman/mason.nvim',
			build = function()
				pcall(vim.cmd, 'MasonUpdate')
			end,
		        },
		        {'williamboman/mason-lspconfig.nvim'}, -- Optional

		        -- Autocompletion
		        {'hrsh7th/nvim-cmp'},     -- Required
		        {'hrsh7th/cmp-nvim-lsp'}, -- Required
		        {'L3MON4D3/LuaSnip'},     -- Required
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
	{
		"terrortylor/nvim-comment",
		config = function()
			require('nvim_comment').setup({})
		end,
	},
	{
		"fedepujol/move.nvim",
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
	},
	{
		"github/copilot.vim",
		lazy=false,
		config = function()
		end,
	},
	{
		'darrikonn/vim-gofmt',
		ft = 'go',
	},
}

require("lazy").setup(plugins, {lazy=true})
