return {
	{
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter" },
		event = "InsertEnter",
	},
	{ "jiangmiao/auto-pairs" },
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 500
		end,
		opts = {},
	},
	{
		"tpope/vim-fugitive",
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
			vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", {})
			vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", {})
		end,
	},
	{
		"barrett-ruth/live-server.nvim",
		build = "pnpm add -g live-server",
		cmd = { "LiveServerStart", "LiveServerStop" },
		config = true,
	},
	{
		"nvimdev/lspsaga.nvim",
		event = "LspAttach",
		config = function()
			require("lspsaga").setup({
				lightbulb = {
					enable = false,
				},
			})
			vim.keymap.set(
				"n",
				"gd",
				"<cmd>Lspsaga peek_definition<CR>",
				{ noremap = true, silent = true, desc = "Peek definition in floating window" }
			)
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},
}
