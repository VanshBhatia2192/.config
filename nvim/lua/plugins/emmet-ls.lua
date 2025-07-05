return {
    "aca/emmet-ls",
    config = function()
        local lspconfig = require("lspconfig")
        lspconfig.emmet_ls.setup({
            filetypes = {
                "html",
                "css",
                "javascriptreact",
                "typescriptreact",
                "javascript",
                "typescript",
                "vue",
                "svelte",
                "xml",
            },
            init_options = {
                html = {
                    options = {
                        ["bem.enabled"] = true,
                    },
                },
            },
        })
    end,
}