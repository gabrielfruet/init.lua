return {
    'L3MON4D3/LuaSnip',
    config = function()
        require("luasnip.loaders.from_snipmate").lazy_load({
            paths = {
                vim.fn.expand('~/.config/nvim/lua/fruet/snippets')
            }
        })
    end,
    build = "make install_jsregexp"
}
