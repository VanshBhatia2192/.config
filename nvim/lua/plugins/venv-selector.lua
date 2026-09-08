return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
	},
	branch = "regexp",
	config = function()
		require("venv-selector").setup({
			settings = {
				options = {
					notify_user_on_venv_activation = true,
				},
				search = {
					-- Uses fd natively via the plugin's built-in picker logic
					-- to safely look for '.venv' folders anywhere in your project root
					my_uv_envs = {
						name = ".venv",
					},
				},
			},
		})
	end,
	keys = {
		{ "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select Virtual Env" },
	},
}
