return {
	{
		"nanozuki/tabby.nvim",
		config = function()
			vim.o.showtabline = 2
			require("tabby").setup({
				line = function(line)
					local blue = "#89b4fa"
					local white = "#FFFFFF"
					return {
						{
							{ "  ", hl = { bg = "NONE" } },
							line.tabs().foreach(function(tab)
								local hl = tab.is_current() and { fg = blue, bg = "NONE", style = "bold" }
									or { fg = white, bg = "NONE" }
								return {
									" ",
									tab.number(),
									"|",
									tab.name(),
									" ",
									hl = hl,
									margin = " ",
								}
							end),
							line.spacer(),
						},
						hl = { bg = "NONE" },
					}
				end,
				option = {
					nerdfont = true,
				},
			})
		end,
	},
}
