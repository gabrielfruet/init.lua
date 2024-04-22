return {
    "mfussenegger/nvim-lint",
    event={
        "BufReadPre",
        "BufNewFile"
    },
    config = function ()
        local nvim_lint = require('lint')
        nvim_lint.linters_by_ft = {
            python={'pylint'},
            bash={'shellcheck'},
            shell={'shellcheck'},
        }
        local linaugroup = vim.api.nvim_create_augroup("Linting", {clear = true})
        vim.api.nvim_create_autocmd({ "BufWritePost" , "BufEnter", "InsertLeave"}, {
            group = linaugroup,
            callback = function()
                nvim_lint.try_lint()
            end,
        })
        vim.keymap.set('n', '<leader>li', function ()
            nvim_lint.try_lint()
        end, {noremap=true})

        --for pylint to work with venv
        --require('lint').linters.pylint.cmd = 'python'
        --require('lint').linters.pylint.args = {'-m', 'pylint', '-f', 'json'}

    end
}
