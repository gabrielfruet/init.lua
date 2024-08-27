return {
    {
        'neovim/nvim-lspconfig',
        config = function ()
            require("neodev").setup({})
            local c = require'lspconfig'
            c.lua_ls.setup({
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT',
                            path = {
                                '?/init.lua',
                                '?.lua'
                            }
                        },
                        workspace = {
                            library = {
                                '/usr/share/nvim/runtime/lua',
                                '/usr/share/nvim/runtime/lua/lsp',
                                '/usr/share/awesome/lib'
                            }
                        },
                        completion = {
                            enable = true,
                        },
                        diagnostics = {
                            enable = true,
                            globals = { 'vim', 'awesome', 'client', 'root' }
                        },
                        telemetry = {
                            enable = false
                        }
                    }
                }        })
            --c.rust_analyzer.setup{}
            c.pyright.setup{
                exclude= { ".venv" },
                venvPath= ".",
                venv= ".venv",
            }
            c.clangd.setup{}
            c.cmake.setup{}
            c.bashls.setup{}
            c.texlab.setup{}
            c.gopls.setup{}
            c.ocamllsp.setup{}
        end
    },
    {
        'onsails/lspkind-nvim',
    }

}
