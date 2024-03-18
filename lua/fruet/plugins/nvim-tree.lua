return {
    'kyazdani42/nvim-tree.lua',
    dependencies = 'kyazdani42/nvim-web-devicons',
    config = function ()
        local api = require('nvim-tree.api')
        local map = vim.keymap.set

        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        map('n', '<c-n>', api.tree.toggle, { noremap = true })
    end,
    opts = {
        {
            sort_by = "case_sensitive",
            view = {
                adaptive_size = true,
                --mappings = {
                --list = {
                --{ key = "u", action = "dir_up" },
                --},
                --},
            },
            renderer = {
                group_empty = true,
            },
            filters = {
                dotfiles = true,
            },
        }
    }
}



