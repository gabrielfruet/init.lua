return {
    'kyazdani42/nvim-tree.lua',
    lazy=false,
    dependencies = 'kyazdani42/nvim-web-devicons',
    config = function ()
        require('nvim-tree').setup{
            sort = {
                sorter = "case_sensitive",
            },
            view = {
                width = 30,
            },
            renderer = {
                group_empty = true,
            },
            filters = {
                dotfiles = true,
            },
        }
        local api = require('nvim-tree.api')
        local map = vim.keymap.set

        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        map('n', '<c-n>', api.tree.toggle, { noremap = true })
    end,
}



