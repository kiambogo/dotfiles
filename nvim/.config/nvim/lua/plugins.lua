local plugins = {
	{ 'nvim-lua/plenary.nvim' },
	{ 'sindrets/diffview.nvim' },
	{ "NeogitOrg/neogit", dependencies = { 'sindrets/diffview.nvim' } },
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
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v4.x',
		lazy = true,
		config = false
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
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.confirm({select = true})
							-- Exit insert mode after accepting completion
							vim.schedule(function()
								vim.cmd('stopinsert')
							end)
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

			-- Ensure Mason binaries are in PATH
			local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
			vim.env.PATH = mason_bin .. ":" .. vim.env.PATH

			-- Setup mason FIRST
			require('mason').setup()

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
					-- Custom handler for gopls
					gopls = function()
						local util = require('lspconfig.util')

						-- Use gopls from ~/go/bin (compiled with correct Go version)
						local gopls_path = vim.fn.expand('~/go/bin/gopls')
						local goroot = vim.fn.system('go env GOROOT'):gsub('\n', '')

						lsp_config.gopls.setup({
							-- For Go workspaces, prioritize go.work, otherwise find go.mod
							root_dir = util.root_pattern('go.work', 'go.mod', '.git'),
							cmd = { gopls_path },
							cmd_env = {
								GOROOT = goroot,
								PATH = vim.env.PATH,
							},
							settings = {
								gopls = {
									directoryFilters = {
										"-**/node_modules",
										"-**/.git",
										"-**/vendor",
									},
									analyses = {
										unusedparams = true,
										shadow = true,
									},
									staticcheck = true,
									gofumpt = true,
								}
							},
						})
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
			local actions = require("fzf-lua.actions")

			-- Helper function to navigate to parent directory
			local function navigate_to_parent(selected, opts)
				local parent = vim.fn.fnamemodify(opts.cwd or vim.fn.getcwd(), ":h")
				opts.cwd = parent
				require("fzf-lua").files(opts)
			end

			require("fzf-lua").setup({
				files = {
					actions = {
						["tab"] = function(selected, opts)
							-- If selected item is a directory, cd into it
							local entry = selected[1]
							if entry then
								local path = require("fzf-lua").path.entry_to_file(entry, opts).path
								if vim.fn.isdirectory(path) == 1 then
									opts.cwd = path
									require("fzf-lua").files(opts)
								else
									actions.file_edit(selected, opts)
								end
							end
						end,
						["shift-tab"] = navigate_to_parent,
						["del"] = navigate_to_parent,
						["backspace"] = navigate_to_parent,
					}
				},
				keymap = {
					builtin = {
						["<C-d>"] = "preview-page-down",
						["<C-u>"] = "preview-page-up",
					},
				},
			})
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
		"github/copilot.vim",
		lazy = false,
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
