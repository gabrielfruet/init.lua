return {
    'lewis6991/gitsigns.nvim',
    config=function ()
        local gitsigns = require('gitsigns')
        gitsigns.setup{
            on_attach = function ()
                vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk)
            end,
        }
    end,
}
