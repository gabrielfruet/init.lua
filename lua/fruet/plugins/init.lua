local function exists(name)
    local f=vim.fn.isdirectory(vim.fn.expand(name))
    return f == 1
end

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
        enabled=false,
        config = function()
            require'lsp_signature'.setup {
            bind=true,
            hint_prefix = {
                above = "↙ ",  -- when the hint is on the line above the current line
                current = "← ",  -- when the hint is on the same line
                below = "↖ "  -- when the hint is on the line below the current line
            },
            handler_opts = {
                border = "rounded",
            }
        }
        end
    },
    {
        'jpalardy/vim-slime',
        init = function ()
            vim.g.slime_no_mappings = 1
        end,
        config =function ()
            vim.g.slime_target = "tmux"
            vim.g.slime_bracketed_paste = 1
            vim.g.slime_default_config = {
                socket_name="default", target_pane="1"
            }
            vim.g.slime_dont_ask_default = 1
            vim.cmd[[vmap <leader>s <Plug>SlimeRegionSend]]

            vim.cmd[[nmap <leader>ss <Plug>SlimeParagraphSend]]
            vim.cmd[[nmap <leader>sl <CMD>SlimeSend<CR>]]
        end
    },
    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({})
        end,
    },
    {
        'gabrielfruet/mint.nvim',
        dir="~/dev/lua/mint",
        dev=true,
        opts={}
    },
    {
        dir="~/dev/lua/constructor",
        dev=true,
        enabled=exists("~/dev/lua/constructor"),
        opts={}
    }
}
