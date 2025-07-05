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
}
