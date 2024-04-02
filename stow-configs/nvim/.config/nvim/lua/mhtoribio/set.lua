vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.errorbells = false

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.scrolloff = 4

vim.opt.termguicolors = true

vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"

vim.g.mapleader = " "

-- Turn off automatic commenting on newline
vim.cmd([[autocmd BufEnter * set formatoptions-=c formatoptions-=r formatoptions-=o]])

-- Make nvim recognize .slint files
vim.cmd([[autocmd BufEnter *.slint :setlocal filetype=slint]])

vim.g.netrw_banner = 0
