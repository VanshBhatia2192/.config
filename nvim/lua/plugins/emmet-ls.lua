return {
	"aca/emmet-ls",
	config = function()
		-- 1. Define the configuration
		vim.lsp.config("emmet_ls", {
			filetypes = {
				"html",
				"css",
				"javascriptreact",
				"typescriptreact",
				"javascript",
				"typescript",
				"vue",
				"svelte",
				"xml",
			},
			init_options = {
				html = {
					options = {
						["bem.enabled"] = true,
					},
				},
			},
		})

		-- 2. Enable the server natively
		vim.lsp.enable("emmet_ls")
	end,
}
