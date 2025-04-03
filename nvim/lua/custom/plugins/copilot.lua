local copilot_disabled_dirs = {}
-- Disable Copilot for specific directories

vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		local current_file = vim.fn.expand("%:p") -- Get the full path of the current file
		for _, dir in ipairs(copilot_disabled_dirs) do
			if current_file:find(vim.fn.expand(dir), 1, true) then
				-- Disable Copilot
				vim.g.copilot_enabled = false
				return
			end
		end
		-- Enable Copilot for other directories
		vim.g.copilot_enabled = true
	end,
})
return {
	{
		"github/copilot.vim",
	},
}
