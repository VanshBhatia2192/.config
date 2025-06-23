return {
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		config = function()
			local logo = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
            ]]

			logo = string.rep("\n", 13) .. logo .. "\n\n"
			require("dashboard").setup({
				theme = "doom",
				hide = {
					statusline = true,
				},
				config = {
					header = vim.split(logo, "\n"),
					center = {
						{
							desc = "Bazinga",
						},
					},
					footer = function()
						local stats = require("lazy").stats()
						return { string.format("%d/%d plugins loaded", stats.loaded, stats.count) }
					end,
				},
			})
		end,
	},
}
