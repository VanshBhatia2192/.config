return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "saadparwaiz1/cmp_luasnip",
        "L3MON4D3/LuaSnip",
        "simrat39/rust-tools.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        vim.cmd [[ highlight DiagnosticVirtualTextWarn guibg=NONE ]]
        vim.cmd [[ highlight DiagnosticVirtualTextInfo guibg=NONE ]]
        vim.cmd [[ highlight DiagnosticVirtualTextError guibg=NONE ]]
        vim.cmd [[ highlight DiagnosticVirtualTextHint guibg=NONE ]]
        vim.cmd [[ highlight DiagnosticVirtualTextOk guibg=NONE ]]

        local lspconfig = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local luasnip = require("luasnip")
        local rt = require("rust-tools")
        local cmp = require("cmp")

        rt.setup({
            server = {
                on_attach = function(_, bufnr)
                    -- Hover actions
                    vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
                    -- Code action groups
                    vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
                end,
                settings = {
                    -- to enable rust-analyzer settings visit:
                    -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
                    ["rust-analyzer"] = {
                        -- enable clippy on save
                        checkOnSave = {
                            command = "clippy",
                        },
                    },
                },
            },
        })

        -- Specify how the border looks like
        local border = {
            { "╭", "FloatBorder" },
            { "─", "FloatBorder" },
            { "╮", "FloatBorder" },
            { "│", "FloatBorder" },
            { "╯", "FloatBorder" },
            { "─", "FloatBorder" },
            { "╰", "FloatBorder" },
            { "│", "FloatBorder" },
        }

        -- Add the border on hover and on signature help popup window
        local handlers = {
            ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
            ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
            ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
        }

        vim.diagnostic.config({
            virtual_text = {
                prefix = "●", -- Could be '●', '▎', 'x', '■', , 
            },
            float = { border = border },
        })

        lspconfig.pyright.setup({
            root_dir = vim.loop.cwd,
            settings = {
                python = {
                    analysis = {
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = "openFilesOnly",
                        typeCheckingMode = "off",
                    },
                },
            },
            capabilities = capabilities,
            handlers = handlers,
        })

        local servers = { "clangd", "lua_ls", "jsonls", "gopls" }

        for _, lsp in ipairs(servers) do
            lspconfig[lsp].setup({
                -- on_attach = my_custom_on_attach,
                capabilities = capabilities,
                handlers = handlers,
            })
        end

        vim.api.nvim_set_hl(0, "CmpNormal", { bg = "#1E1E2F" })
        vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1E1E2F" })


        for _, diag in ipairs({ "Error", "Warn", "Info", "Hint" }) do
            vim.fn.sign_define("DiagnosticSign" .. diag, {
                text = "",
                texthl = "DiagnosticSign" .. diag,
                linehl = "",
                numhl = "DiagnosticSign" .. diag,
            })
        end

        local ELLIPSIS_CHAR = "…"
        local MAX_LABEL_WIDTH = 20
        local MIN_LABEL_WIDTH = 20

        cmp.setup({
            formatting = {
                format = function(entry, vim_item)
                    local label = vim_item.abbr
                    local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
                    if truncated_label ~= label then
                        vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
                    elseif string.len(label) < MIN_LABEL_WIDTH then
                        local padding = string.rep(" ", MIN_LABEL_WIDTH - string.len(label))
                        vim_item.abbr = label .. padding
                    end
                    return vim_item
                end,
            },
            window = {
                documentation = {
                    border = "rounded",
                    winhighlight = "Normal:CmpNormal",
                },
                completion = {
                    border = "rounded",
                    winhighlight = "Normal:CmpNormal",
                },
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        local entry = cmp.get_selected_entry()
                        if not entry then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                            cmp.confirm()
                        else
                            cmp.confirm()
                        end
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            view = {
                entries = { name = "custom", selection_order = "near_cursor" },
            },
            sources = {
                { name = "nvim_lsp" },
                { name = "luasnip" },
            },
        })

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local opts = { buffer = ev.buf }
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
                vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
                vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
                vim.keymap.set("n", "<space>wl", function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, opts)
                vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
                vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "<space>f", function()
                    vim.lsp.buf.format({ async = true })
                end, opts)
            end,
        })
    end,
}
