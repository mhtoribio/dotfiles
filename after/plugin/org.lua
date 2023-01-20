-- Load custom treesitter grammar for org filetype
require('orgmode').setup_ts_grammar()

-- Treesitter configuration
require('nvim-treesitter.configs').setup {
    -- If TS highlights are not enabled at all, or disabled via `disable` prop,
    -- highlighting will fallback to default Vim syntax highlighting
    highlight = {
        enable = true,
        -- Required for spellcheck, some LaTex highlights and
        -- code block highlights that do not have ts grammar
        additional_vim_regex_highlighting = {'org'},
    },
    ensure_installed = {'org'}, -- Or run :TSUpdate org
}

require('orgmode').setup({
    org_agenda_files = {'~/Dropbox/org/*', '~/my-orgs/**/*'},
    org_default_notes_file = '~/Dropbox/org/refile.org',
    -- Remaps
    mappings = {
        org = {
            org_toggle_checkbox = "cic"
        }
    }
})

-- Custom capture templates
org_capture_templates = {
    t = {
        description = 'Task',
        template = '* TODO %?\n  %u'
    },
    h = {
        description = "Habit",
        template = "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n",
        target = "~/Dropbox/org/refile.org"
    },
    s = {
        description = "Shopping",
        template = "+ [ ] %?",
        target = "~/Dropbox/org/shopping.org"
    }
}

-- Conceal links properly
vim.opt.conceallevel = 2
vim.opt.concealcursor = 'nc'
