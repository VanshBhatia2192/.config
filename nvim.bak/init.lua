require("vansh.core")
require("vansh.lazy")

vim.env.PYTHONPATH = "/Users/vanshbhatia/site-packages/"
vim.g.python3_host_prog = "/opt/homebrew/bin/bin/python3"

local uncrustify_cfg_file_path = vim.fn.expand("~/.uncrustify.cfg")

-- Function to run Uncrustify on the current buffer
local function Uncrustify()
	vim.cmd("silent !uncrustify -q -l java -c " .. uncrustify_cfg_file_path)
end

local excluded_extensions = { ".c", ".cpp" }

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.java", -- Include Java files for now
	callback = function()
		local current_file = vim.api.nvim_buf_get_name(0)
		local _, ext = current_file:match("%.(.*)$")

		if not vim.tbl_contains(excluded_extensions, ext) then
			Uncrustify()
		end
	end,
})
