return {
    "mfussenegger/nvim-lint",
    event={
        "BufReadPre",
        "BufNewFile"
    },
    config = function ()
        local nvim_lint = require('lint')
        nvim_lint.linters_by_ft = {
            python={'ruff'},
            lua={'luacheck'},
            bash={'shellcheck'},
            shell={'shellcheck'},
            make={'checkmake'},
        }
        local linaugroup = vim.api.nvim_create_augroup("Linting", {clear = true})
        vim.api.nvim_create_autocmd({ "BufWritePost" , "BufEnter", "InsertLeave"}, {
            group = linaugroup,
            callback = function()
                nvim_lint.try_lint()
            end,
        })
        vim.api.nvim_create_user_command("Lint",function()
                nvim_lint.try_lint()
            end, {}
        )
        vim.keymap.set('n', '<leader>li', function ()
            nvim_lint.try_lint()
        end, {noremap=true})

        -- Luacheck with global vim
        nvim_lint.linters.luacheck.args = {
            '--formatter', 'plain',    -- Use plain text for output
            '--codes',                 -- Show warning codes
            '--globals', 'vim',        -- Declare 'vim' as a global
            '--',                      -- End of options for luacheck
        }
    end
}
