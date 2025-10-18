local plugins = {
	{ 'nvim-lua/plenary.nvim' },
	{ "NeogitOrg/neogit" },
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
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				init = function()
					-- disable rtp plugin, as we only need its queries for mini.ai
					-- In case other textobject modules are enabled, we will load them
					-- once nvim-treesitter is loaded
					require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
					load_textobjects = true
				end,
			},
		},
		cmd = { "TSUpdateSync" },
		opts = {
			highlight = { enable = true },
			indent = { enable = true },
			ensure_installed = {
				"bash",
				"go",
				"html",
				"javascript",
				"json",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"python",
				"regex",
				"vim",
				"vimdoc",
				"yaml",
				"terraform",
			},
		},
		config = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				---@type table<string, boolean>
				local added = {}
				opts.ensure_installed = vim.tbl_filter(function(lang)
					if added[lang] then
						return false
					end
					added[lang] = true
					return true
				end, opts.ensure_installed)
			end
			require("nvim-treesitter.configs").setup(opts)

			if load_textobjects then
				-- PERF: no need to load the plugin, if we only need its queries for mini.ai
				if opts.textobjects then
					for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
						if opts.textobjects[mod] and opts.textobjects[mod].enable then
							local Loader = require("lazy.core.loader")
							Loader.disabled_rtp_plugins["nvim-treesitter-textobjects"] = nil
							local plugin = require("lazy.core.config").plugins["nvim-treesitter-textobjects"]
							require("lazy.core.loader").source_runtime(plugin.dir, "plugin")
							break
						end
					end
				end
			end
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("lsp")
		end,
	},
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v4.x',
		lazy = true,
		config = function()
			-- This is where you modify the settings for lsp-zero
			-- Note: autocompletion settings will not take effect

			require('lsp-zero.settings').preset({})
		end
	},
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			{'L3MON4D3/LuaSnip'},
			{'hrsh7th/cmp-nvim-lsp'},
		},
		config = function()
			local cmp = require('cmp')
			local luasnip = require('luasnip')

			cmp.setup({
				sources = {
					{name = 'nvim_lsp'},
					{name = 'luasnip'},
				},
				mapping = cmp.mapping.preset.insert({
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-f>'] = cmp.mapping(function(fallback)
						if luasnip.jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, {'i', 's'}),
					['<C-b>'] = cmp.mapping(function(fallback)
						if luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, {'i', 's'}),
					['<CR>'] = cmp.mapping.confirm({select = false}),
				}),
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
			})
		end
	},
	{
		'neovim/nvim-lspconfig',
		cmd = 'LspInfo',
		event = {'BufReadPre', 'BufNewFile'},
		dependencies = {
			{'hrsh7th/cmp-nvim-lsp'},
			{'williamboman/mason-lspconfig.nvim'},
			{
				'williamboman/mason.nvim',
				build = function()
					pcall(vim.cmd, 'MasonUpdate')
				end,
			},
		},
		config = function()
			local lsp_zero = require('lsp-zero')
			local lsp_config = require('lspconfig')

			-- Setup mason-lspconfig to auto-install servers
			require('mason-lspconfig').setup({
				ensure_installed = {
					'lua_ls',
					'gopls',
					'pylsp',
				},
				handlers = {
					-- Default handler for all servers
					function(server_name)
						lsp_config[server_name].setup({})
					end,
					-- Custom handler for lua_ls
					lua_ls = function()
						lsp_config.lua_ls.setup({
							settings = {
								Lua = {
									runtime = { version = 'LuaJIT' },
									workspace = {
										checkThirdParty = false,
										library = {
											vim.env.VIMRUNTIME
										}
									},
									diagnostics = {
										globals = { 'vim' }
									}
								}
							}
						})
					end,
				}
			})
		end
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
		"alexghergh/nvim-tmux-navigation",
		config = function()
			require'nvim-tmux-navigation'.setup {
				disable_when_zoomed = true,
				keybindings = {
					left = "<C-h>",
					down = "<C-j>",
					up = "<C-k>",
					right = "<C-l>",
					last_active = "<C-\\>",
					next = "<C-Space>",
				}
			}
		end
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
	{
		"sainnhe/edge"
	},
	{
		"almo7aya/openingh.nvim"
	},
}

require("lazy").setup(plugins, {lazy=true})
