local function neodev_before()
    require("neodev").setup({
        override = function(root_dir, library)
            library.enabled = true
            library.plugins = true
        end,
    })
end

return {
    'neovim/nvim-lspconfig',
    config = function ()
        neodev_before()
        local c = require'lspconfig'
        c.lua_ls.setup({
            settings = {
                Lua = {
                    completion = {
                        callSnippet = "Replace"
                    },
                    diagnostics = {
                        globals = {'vim'}
                    }
                }
            }
        })
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
    end
}
