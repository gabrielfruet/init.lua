return {
    'neovim/nvim-lspconfig',
    config = function ()
        local c = require'lspconfig'
        require('neodev').setup()
        c.lua_ls.setup {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = {
                            'vim',
                            'require'
                        },
                    },
                    workspace = {
                        -- Make the server aware of Neovim runtime files
                        library = vim.api.nvim_get_runtime_file("", true),
                    },
                    completion = {
                        callSnippet = "Replace"
                    }
                },
            },
        }
        c.rust_analyzer.setup{}
        c.clangd.setup{}
        c.tsserver.setup{}
        c.eslint.setup{}
        c.bashls.setup{}
        c.gopls.setup{}
        c.pyright.setup{}
    end
}
