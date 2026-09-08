return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"pyright",
					"eslint",
					"tailwindcss",
					"cssls",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- ====================================================================
			-- 1. DIAGNOSTICS CONFIGURATION (Replaces vim.lsp.with)
			-- ====================================================================
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
			})

			-- ====================================================================
			-- 2. INDUSTRY STANDARD DIAGNOSTIC DEDUPLICATOR
			-- ====================================================================
			local original_publish_diagnostics = vim.lsp.diagnostic.on_publish_diagnostics

			-- Intercept incoming LSP diagnostics to filter out identical line collisions
			vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
				local client = vim.lsp.get_client_by_id(ctx.client_id)

				if client and result and result.diagnostics then
					local seen_lines = {}
					local filtered_diagnostics = {}

					for _, diagnostic in ipairs(result.diagnostics) do
						local key = string.format(
							"%d:%d:%s",
							diagnostic.range.start.line,
							diagnostic.range.start.character,
							diagnostic.message
						)

						if not seen_lines[key] then
							seen_lines[key] = true
							table.insert(filtered_diagnostics, diagnostic)
						end
					end
					result.diagnostics = filtered_diagnostics
				end

				-- Pass the clean, deduplicated diagnostics back to Neovim's rendering pipeline
				original_publish_diagnostics(err, result, ctx, config)
			end

			-- ====================================================================
			-- 3. GLOBAL KEYMAPS (Replaces repetitive on_attach)
			-- ====================================================================
			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP keybindings",
				callback = function(event)
					local bufnr = event.buf
					vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
					vim.keymap.set("n", "od", function()
						local params = vim.lsp.util.make_position_params(0, "utf-8")
						vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result)
							if not result or vim.tbl_isempty(result) then
								vim.notify("No definition found", vim.log.levels.INFO)
								return
							end
							local def = (vim.islist(result) and result[1]) or result
							vim.cmd("tabnew")
							vim.lsp.util.show_document(def, "utf-8")
						end)
					end, { buffer = bufnr, noremap = true, silent = true, desc = "Open definition in new tab" })
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })
					vim.keymap.set(
						"i",
						"<C-s>",
						vim.lsp.buf.signature_help,
						{ buffer = bufnr, desc = "Signature Help" }
					)
				end,
			})

			-- ====================================================================
			-- 4. SERVER CONFIGURATIONS (Neovim 0.11 API)
			-- ====================================================================

			-- lua_ls
			vim.lsp.config("lua_ls", { capabilities = capabilities })
			vim.lsp.enable("lua_ls")

			-- ts_ls
			vim.lsp.config("ts_ls", {
				capabilities = capabilities,
				settings = {
					typescript = {
						diagnostics = { ignoredCodes = { 6133, 6196 } },
					},
					javascript = {
						diagnostics = { ignoredCodes = { 6133, 6196 } },
					},
				},
			})
			vim.lsp.enable("ts_ls")

			-- pyright
			vim.lsp.config("pyright", {
				capabilities = capabilities,
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "workspace",
						},
					},
				},
			})
			vim.lsp.enable("pyright")

			-- tailwindcss
			vim.lsp.config("tailwindcss", { capabilities = capabilities })
			vim.lsp.enable("tailwindcss")

			-- cssls
			vim.lsp.config("cssls", {
				capabilities = capabilities,
				settings = {
					css = { validate = true, lint = { unknownAtRules = "ignore" } },
					scss = { validate = true, lint = { unknownAtRules = "ignore" } },
					less = { validate = true, lint = { unknownAtRules = "ignore" } },
				},
			})
			vim.lsp.enable("cssls")
		end,
	},
}
