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
            -- c.pyright.setup{
            --     exclude= { ".venv" },
            --     venvPath= ".",
            --     venv= ".venv",
            -- }
            c.basedpyright.setup{
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = 'openFilesOnly',
                        },
                    },
                    basedpyright = {
                        typeCheckingMode="standard"
                    }

                },
                -- settings={
                --     basedpyright = {
                --         typeCheckingMode="standard"
                --     }
                -- }
            }
            c.clangd.setup{}
            c.cmake.setup{}
            c.bashls.setup{}
            c.texlab.setup{}
            c.gopls.setup{}
            c.ocamllsp.setup{}
            c.julials.setup{}
            c.dockerls.setup{}
        end
    },
    {
        'onsails/lspkind-nvim',
        config = function ()
            local lspkind = require('lspkind')
            lspkind.init{
                symbol_map={
                    Copilot = "",
                }
            }
        end
    }

}
