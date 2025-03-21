pcall(vim.cmd('source ~/.cache/wal/colors-wal.vim'))

vim.g.mapleader = " "
vim.opt.guicursor = ""
vim.opt.clipboard="unnamedplus"

vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.scrolloff = 8

-- Give more space for displaying messages.
vim.opt.cmdheight = 1
vim.opt.wrap = false

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 50
vim.opt.termguicolors=true
--vim.opt.winblend = 0
vim.opt.laststatus = 2
vim.opt.background='dark'
vim.opt.fillchars = {
    stl = "─"
}
vim.opt.showmode = false
vim.cmd[[set rtp^="/home/fruet/.opam/default/share/ocp-indent/vim"]]


--vim.cmd[[set -g default-terminal "xterm-256color"]]
--vim.cmd[[set-option -ga terminal-overrides ",xterm-256color:Tc"]]

-- Don't pass messages to |ins-completion-menu|.

--vim.opt.guifont="JetBrainsMono Nerd Font"
--vim.opt.guifont="FiraCode Nerd Font"
--vim.opt.guifont="Iosevka Nerd Font"
