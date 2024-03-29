return {
    {
        "neovim/nvim-lspconfig",
        cmd = "DiagnosticsSeverityVirtualText",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lspconfig = require("lspconfig")

            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    local opts = {buffer = event.buf}
                    vim.keymap.set('n', '<leader>vgd', function() vim.lsp.buf.definition() end, opts)
                    vim.keymap.set('n', '<leader>vgD', function() vim.lsp.buf.declaration() end, opts)
                    vim.keymap.set('n', '<leader>vgi', function() vim.lsp.buf.implementation() end, opts)
                    vim.keymap.set('n', '<leader>vgt', function() vim.lsp.buf.type_definition() end, opts)
                    vim.keymap.set('n', '<leader>vgs', function() vim.lsp.buf.signature_help() end, opts)
                    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
                    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
                    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
                    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
                    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
                    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
                    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
                end
            })

            -- Stop annoying line movements when entering and exiting insert mode
            vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {update_in_insert = true}
            )

            function DiagnosticsSeverityVirtualText(level)
                vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics, {
                    virtual_text = {
                        severity_limit = level,
                    },
                }
                )
            end

            -- Set virtual text to error only
            -- Reloads the file if it has not been modified
            vim.keymap.set("n", "<leader>q", function() DiagnosticsSeverityVirtualText("Error"); if vim.fn.getbufvar('%', '&modified')==0 then vim.cmd("edit") end end)

        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies =  {
            "williamboman/mason.nvim",
            config = function()
                require("mason").setup()
            end,
        },
        config = function()
            require("mason-lspconfig").setup {
                ensure_installed = {
                    "clangd",
                    "rust_analyzer",
                },
            }
            require("mason-lspconfig").setup_handlers {
                function (server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {}
                end,
            }
        end
    },
    {
        "rust-lang/rust.vim",
        ft = "rust",
        init = function()
            vim.g.rustfmt_autosave = 1
        end
    },
}
