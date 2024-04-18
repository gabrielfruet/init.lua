return{
    "hrsh7th/nvim-cmp",
    --Don't remove the event line, it breaks cmd completion.
    event={'InsertEnter', 'CmdlineEnter'},
    dependencies = {
        "hrsh7th/cmp-buffer",
        'hrsh7th/cmp-path',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
        'rafamadriz/friendly-snippets',
        'onsails/lspkind-nvim',
        "hrsh7th/cmp-nvim-lsp",
        --'quangnguyen30192/cmp-nvim-ultisnips',
        'hrsh7th/cmp-nvim-lua',
        'octaltree/cmp-look',
        'hrsh7th/cmp-calc',
        'f3fora/cmp-spell',
        'hrsh7th/cmp-emoji',
        'tamago324/cmp-zsh',
        'hrsh7th/cmp-cmdline'
    },
    config = function ()
        local cmp = require'cmp'
        local lspkind = require('lspkind')
        local luasnip = require('luasnip')

        cmp.setup({
            formatting = {
                format = lspkind.cmp_format({
                    mode = 'symbol_text', -- show only symbol annotations
                    maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                    -- can also be a function to dynamically calculate max width such as 
                    -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
                    ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                    show_labelDetails = true, -- show labelDetails in menu. Disabled by default

                    -- The function below will be called before any actual modifications from lspkind
                    -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                    before = function (entry, vim_item) return vim_item end
                })
            },
            completion = {
                compleopt = "menu,menuone,preview,noselect"
            },
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            window = {
                completion = cmp.config.window.bordered{border="rounded"},
                documentation = cmp.config.window.bordered{border="rounded"},
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = function ()
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    end
                end,
                ['<C-n>'] = function ()
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.jumpable(1) then
                        luasnip.jump(1)
                    end
                end,
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-x>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true, behavior=cmp.ConfirmBehavior.Replace })-- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'emoji'},
                { name = 'calc'},
                { name = 'look'},
                { name = 'spell' },
                { name = 'path' },
                { name = 'buffer' },
            })
        })

        -- Set configuration for specific filetype.
        cmp.setup.filetype('gitcommit', {
            sources = cmp.config.sources({
                { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
            }, {
                    { name = 'buffer' },
                })
        })

        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        -- DO NOT UNCOMMENT THIS, CMDLINE WILL STOP WORKING
        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        ---[[
        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' }
            }, {
                { name = 'cmdline' }
            })
        })
        --]]
        cmp.setup.filetype("tex", {
            sources = {
                { name = 'luasnip' },
                { name = 'nvim_lsp' },
                { name = 'vimtex' },
                { name = 'buffer' },
            },
        })

    end
}
