return {
    "mfussenegger/nvim-lint",
    enabled=false,
    event='BufWritePost',
    config = function ()
        local nvim_lint = require('lint')
        nvim_lint.linters_by_ft = {
            python={'pylint'},
            lua={'luacheck'},
            bash={'shellcheck'},
            shell={'shellcheck'}
        }
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            callback = function()
                nvim_lint.try_lint()
            end,
        })
        vim.keymap.set('n', '<leader>l', function ()
            nvim_lint.try_lint()
        end, {noremap=true})

        --for pylint to work with venv
        require('lint').linters.pylint.cmd = 'python'
        require('lint').linters.pylint.args = {'-m', 'pylint', '-f', 'json'}
    end
}
