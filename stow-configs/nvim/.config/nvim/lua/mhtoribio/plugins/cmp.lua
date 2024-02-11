return {
    "hrsh7th/nvim-cmp",
    event = {"InsertEnter"},
    dependencies = {
        {'hrsh7th/cmp-buffer'},
        {'hrsh7th/cmp-path'},
        {"hrsh7th/cmp-nvim-lsp"},
        {"hrsh7th/cmp-nvim-lua"},
        {
            "L3MON4D3/LuaSnip",
            dependencies = {
                {"saadparwaiz1/cmp_luasnip"},
                {"rafamadriz/friendly-snippets"},
            }
        }
    },
    config = function()
        local cmp = require('cmp')
        local cmp_select = {behavior = cmp.SelectBehavior.Select}

        cmp.setup({
            completion = {
                autocomplete = false,
            },
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
}
