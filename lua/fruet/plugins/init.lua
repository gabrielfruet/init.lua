return {
    "romgrk/nvim-treesitter-context",
    {
        'xiyaowong/transparent.nvim',
        config = function ()
            require("transparent").setup({ -- Optional, you don't have to run setup.
                groups = { -- table: default groups
                    'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
                    'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
                    'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
                    'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
                    'EndOfBuffer',
                },
                extra_groups = {}, -- table: additional groups that should be cleared
                exclude_groups = {}, -- table: groups you don't want to clear
            })
        end

    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {},
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {
            bind=true,
            handler_opts = {
                border = "none"
            }
        },
        config = function(_, opts) require'lsp_signature'.setup(opts) end
    },
    {
        'jpalardy/vim-slime',
        init = function ()
            vim.g.slime_no_mappings = 1
        end,
        config =function ()
            vim.g.slime_target = "tmux"
            vim.g.slime_bracketed_paste = 1
            vim.cmd[[xmap <leader>ss <Plug>SlimeRegionSend]]

            vim.cmd[[nmap <leader>ss <Plug>SlimeParagraphSend]]
            vim.cmd[[nmap <leader>sl <CMD>SlimeSend<CR>]]
        end
    },
    {
        dir="~/dev/lua/seem",
        opts={},
        dev=true,
    }
}
