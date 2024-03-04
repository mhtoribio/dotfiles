return {
    "michaelb/sniprun",
    branch = "master",
    build = "sh install.sh",
    ft = {"markdown"},
    config = function()
        require("sniprun").setup({
            display = {"Classic", "Api"}
        })
        vim.api.nvim_set_keymap('v', '<leader>r', '<Plug>SnipRun', {silent = true})

        local sa = require('sniprun.api')
        local api_listener = function (d)
            if d.status == 'ok' then
                vim.fn.setreg('"', d.message)
            end
        end
        sa.register_listener(api_listener)
    end,
}
