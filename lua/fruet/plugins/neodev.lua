return {
    'folke/neodev.nvim',
    priority=200,
    opts = {
        library = {
            enabled=true,
            runtime=true,
            types=true,
            plugins={"nvim-treesitter", "telescope.nvim", "nvim-cmp"}
        },
        lspconfig=true,
    }
}
