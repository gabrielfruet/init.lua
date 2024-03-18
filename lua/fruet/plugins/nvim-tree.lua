return {
    'kyazdani42/nvim-tree.lua',
    config = function ()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        local map = vim.api.nvim_set_keymap

        map('n', '<c-n>', '<cmd>NvimTreeToggle<cr>', { noremap = true })
    end
}



