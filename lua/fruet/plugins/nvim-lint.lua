return {
    "mfussenegger/nvim-lint",
    enable=false,
    event='BufWritePost',
    config = function ()
        local nvim_lint = require('lint')
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            callback = function()
                nvim_lint.try_lint()
            end,
        })
        vim.keymap.set('n', '<leader>l', function ()
            nvim_lint.try_lint()
        end, {noremap=true})
    end
}
