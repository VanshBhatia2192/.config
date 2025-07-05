return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			auto_install = true,
			-- ensure_installed = { "lua", "javascript", "python", "java", "html", "css", "cpp", "c", "typescript" },
			highlight = { enable = true },
			indent = { enable = true },
			autotag = { enable = true },
		})
	end,

	-- Add nvim-ts-autotag plugin for auto-closing HTML/JSX/TSX tags
	{
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter" },
		event = "InsertEnter",
	},

	-- Add aca/emmet-ls for Emmet-style expansions
	{
		"aca/emmet-ls",
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.emmet_ls.setup({
				filetypes = {
					"html", "css", "javascriptreact", "typescriptreact", "javascript", "typescript", "vue", "svelte", "xml"
				},
				init_options = {
					html = {
						options = {
							["bem.enabled"] = true,
						},
					},
				},
			})
		end,
	},
}
