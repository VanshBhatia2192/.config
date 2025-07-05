return {
	{
		"nanozuki/tabby.nvim",
		config = function()
			vim.o.showtabline = 2
			require("tabby").setup({
				line = function(line)
					local blue = "#89b4fa"
					local white = "#FFFFFF"

					-- Detect file explorer (nvim-tree or neo-tree) and get its width
					local explorer_width = 0
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						local buf = vim.api.nvim_win_get_buf(win)
						local ft = vim.api.nvim_buf_get_option(buf, "filetype")
						if ft == "NvimTree" or ft == "neo-tree" then
							explorer_width = vim.api.nvim_win_get_width(win)
							break
						end
					end

					-- Helper to check if a tab is a file explorer
					local function is_explorer(tab)
						local wins = tab.wins()
						for _, win in ipairs(wins) do
							local buf = vim.api.nvim_win_get_buf(win)
							local ft = vim.api.nvim_buf_get_option(buf, "filetype")
							if ft == "NvimTree" or ft == "neo-tree" then
								return true
							end
						end
						return false
					end

					-- Padding for explorer
					local padding = explorer_width > 0 and string.rep(" ", explorer_width) or ""

					return {
						{
							{ padding, hl = { bg = "NONE" } },
							line.tabs().foreach(function(tab)
								if is_explorer(tab) then
									return nil -- Hide explorer tab
								end
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
