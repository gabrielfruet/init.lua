return{
    {
        "hrsh7th/nvim-cmp",
        --Don't remove the event line, it breaks cmd completion.
        event={'InsertEnter', 'CmdlineEnter'},
        enabled=true,
        dependencies = {
            "hrsh7th/cmp-buffer",
            'hrsh7th/cmp-path',
            'L3MON4D3/LuaSnip',
            'micangl/cmp-vimtex',
            'saadparwaiz1/cmp_luasnip',
            'rafamadriz/friendly-snippets',
            'onsails/lspkind-nvim',
            "hrsh7th/cmp-nvim-lsp",
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-cmdline',
            "kdheepak/cmp-latex-symbols",
            {
                "zbirenbaum/copilot-cmp",
                config = function ()
                    require("copilot_cmp").setup()
                end
            }
        },
        config = function ()
            local cmp = require'cmp'
            local lspkind = require('lspkind')
            local luasnip = require('luasnip')

            local cmp_autopairs = require('nvim-autopairs.completion.cmp')

            -- Insert () on function
            cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()
            )

            cmp.setup({
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        local kind = require("lspkind").cmp_format({
                            mode = "symbol_text",
                            ellipsis_char = '...',
                            maxwidth = 50,
                        })(entry, vim_item)

                        local strings = vim.split(kind.kind, "%s", { trimempty = true })
                        kind.kind = "" .. (strings[1] or "") .. " "
                        kind.menu = " [" .. (strings[2] or "") .. "] "

                        return kind
                    end
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
                    completion = cmp.config.window.bordered{
                        border = "rounded",
                        winhighlight = "CursorLine:CmpPmenuSel,Normal:CmpPmenuNormal"
                    },
                    documentation = cmp.config.window.bordered{
                        border="rounded",
                        winhighlight = "Normal:CmpPmenuNormal,CursorLine:CmpPmenuSel"
                    },
                    -- completion = cmp.config.window.bordered({
                    --     border="none",
                    --     winhighlight = "Normal:CmpPmenuNormal,CursorLine:CmpPmenuSel"
                    -- })
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
                    ['<C-y>'] = cmp.mapping.confirm({ select = true, behavior=cmp.ConfirmBehavior.Replace }),-- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    -- ['<C-c>'] = require('minuet').make_cmp_map()
                }),
                sources = cmp.config.sources(
                    {
                        { name = 'path' },
                        { name = 'nvim_lsp' },
                        { name = 'luasnip' }, -- For luasnip users.
                        { name = 'buffer' },
                        { name = 'vimtex' },
                        { name = "latex_symbols",
                            option = {
                                strategy = 0, -- mixed
                            },},
                    },
                    {
                        { name = 'copilot' },
                    }
                ),
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
                mapping = cmp.mapping.preset.cmdline({
                }),
                sources = {
                    { name = 'buffer' }
                }
            })

            -- DO NOT UNCOMMENT THIS, CMDLINE WILL STOP WORKING
            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            --
            ---[[
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline({
                }),
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
    },
}
