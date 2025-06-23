return {
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<TAB>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					-- { name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "copilot" },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = true, auto_trigger = true },
				panel = { enabled = true },
				filetypes = setmetatable({}, {
					__index = function(_, ft)
						-- Disable Copilot in specific directories
						local disabled_dirs = {
							["/path/to/disable1"] = true,
							["/path/to/disable2"] = true,
						}
						local cwd = vim.loop.cwd()
						for dir in pairs(disabled_dirs) do
							if cwd:find(dir, 1, true) == 1 then
								return false
							end
						end
						return true
					end,
				}),
			})
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		dependencies = { "copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
	},
}
