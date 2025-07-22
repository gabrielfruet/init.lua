return {
    {
        'neovim/nvim-lspconfig',
        config = function ()
            require("neodev").setup({})
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
