return {
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
    {
        -- 'mhtoribio/markdown-image-paste',
        'fred441a/markdown-image-paste',
        -- dir = '~/projects/markdown-image-paste',
        ft = "markdown",
        config = function() 
            require('markdown-image-paste').setup({
                dirname = "images",
                filename = "img",
                custom_filename = true,
            })
            vim.api.nvim_set_keymap('n','<C-i>', "<cmd>lua require('markdown-image-paste').pasteImage()<CR>", {noremap = true})
        end
    }
}
