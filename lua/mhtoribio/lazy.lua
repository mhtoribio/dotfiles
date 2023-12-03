local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {'nvim-lua/plenary.nvim'},
        config = function() require("mhtoribio.plugins.telescope") end,
    },

    {
        "ellisonleao/gruvbox.nvim",
        config = function() require("mhtoribio.plugins.colors") end,
        priority = 1000,
    },

    {
        'nvim-treesitter/nvim-treesitter',
        build = function() vim.fn["TSUpdate"]() end,
        config = function() require("mhtoribio.plugins.treesitter") end
    },
    {
        'theprimeagen/harpoon',
        lazy = false,
        dependencies = {"nvim-lua/plenary.nvim"},
        config = function() require("mhtoribio.plugins.harpoon") end,
    },
    {'tpope/vim-fugitive', config = function() require("mhtoribio.plugins.fugitive") end},

    -- LSP Support
    {
        'VonHeikemen/lsp-zero.nvim',
        branch='v3.x',
        dependencies = {
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp', event = "InsertEnter"},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},
        },
        config = function() require("mhtoribio.plugins.lsp") end,
    },

    {'junegunn/vim-easy-align', config = function() require("mhtoribio.plugins.align") end},
    {
        'numToStr/Comment.nvim',
        lazy = false,
        event = { "BufReadPre", "BufNewFile" },
        config = function() require("mhtoribio.plugins.comment") end,
    },

    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    }
}

require("lazy").setup(plugins, opts)
