vim.lsp.config('lua_ls', {
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
    }
})
--c.rust_analyzer.setup{}
-- c.pyright.setup{
--     exclude= { ".venv" },
--     venvPath= ".",
--     venv= ".venv",
-- }
vim.lsp.config('basedpyright', {
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                autoImportCompletions = true,
            },
        },
        basedpyright = {
            typeCheckingMode="standard"
        }

    },
})
vim.lsp.config('clangd', {})
vim.lsp.config('cmake',{})
vim.lsp.config('bashls', {})
vim.lsp.config('texlab', {})
vim.lsp.config('gopls', {})
vim.lsp.config('ocamllsp', {})
vim.lsp.config('julials', {})
vim.lsp.config('dockerls', {})

