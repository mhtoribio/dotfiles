local lsp_zero_config = {
    call_servers = 'global',
}

local lsp_servers = {
    'lua_ls',
    'clangd',
    'nil_ls',
    'rust_analyzer',
    'pyright',
}

local lua_ls_config = {
    settings = {
        Lua = {
            diagnostics = {globals = {'vim'}},
            runtime = {version = 'LuaJIT'},
            telemetry = {enable = false},
        },
    },
}

local rust_analyzer_config = {
    settings = {
        ["rust-analyzer"] = {
            assist = {
                importGranularity = "module",
                importPrefix = "by_self",
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    }
}

local function on_attach(_, bufnr)
    local opts = {buffer = bufnr}
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

local diagnostics_config = {
	-- what do i even put here
}

return {
    {
        'VonHeikemen/lsp-zero.nvim',
        cmd = "DiagnosticsSeverityVirtualText",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lsp = require('lsp-zero')
            lsp.set_preferences(lsp_zero_config)

            lsp.configure('lua_ls', lua_ls_config)
            lsp.configure('rust_analyzer', rust_analyzer_config)

            lsp.on_attach(on_attach)
            lsp.format_mapping('gq', {
                format_opts = {
                    async = false,
                    timeout_ms = 10000,
                },
                servers = {
                    ['rust_analyzer'] = {'rust'},
                    ['nil_ls'] = {'nixpkgs-fmt'},
                    ['lua_ls'] = {'lua_ls'},
                }
            })
            lsp.setup_servers(lsp_servers)
            lsp.setup()

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

            vim.diagnostic.config(diagnostics_config)
        end,
        dependencies = {
            {'neovim/nvim-lspconfig'},
        },
    },
    {
        "rust-lang/rust.vim",
        ft = "rust",
        init = function()
            vim.g.rustfmt_autosave = 1
        end
    },
    {
        "hrsh7th/nvim-cmp",
        event = {"InsertEnter"},
        dependencies = {
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/nvim-cmp'},
            {
                "L3MON4D3/LuaSnip",
                dependencies = {
                    {"saadparwaiz1/cmp_luasnip"},
                    {"rafamadriz/friendly-snippets"},
                }
            },
        },
        config = function()
            local cmp = require('cmp')
            local cmp_select = {behavior = cmp.SelectBehavior.Select}

            -- cmp turned on by default
            vim.g.cmptoggle = true
            vim.keymap.set("n", "<leader><leader>c", "<cmd>lua vim.g.cmptoggle = not vim.g.cmptoggle<CR>", { desc = "toggle nvim-cmp" })

            cmp.setup({
                enabled = function()
                    return vim.g.cmptoggle
                end,
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                    { name = 'path' },
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
            })
        end
    },
}
