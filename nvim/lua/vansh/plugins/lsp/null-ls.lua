local M = {
	"nvimtools/none-ls.nvim",
}

function M.config()
	local null_ls = require("null-ls")

	local formatting = null_ls.builtins.formatting
	local diagnostics = null_ls.builtins.diagnostics

	null_ls.setup({
		debug = true,
		autostart = true,
		sources = {
			formatting.stylua,
			formatting.prettier,
			formatting.black,
			formatting.shfmt,
			formatting.uncrustify,
			diagnostics.semgrep,
		},
	})
end

return M
