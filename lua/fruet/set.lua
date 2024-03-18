vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.scrolloff = 8

-- Give more space for displaying messages.
vim.opt.cmdheight = 1

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 50
vim.opt.termguicolors=true
--vim.cmd[[set -g default-terminal "xterm-256color"]]
--vim.cmd[[set-option -ga terminal-overrides ",xterm-256color:Tc"]]

-- Don't pass messages to |ins-completion-menu|.
vim.g.mapleader = " "

vim.opt.guifont="JetBrainsMono Nerd Font Mono"
