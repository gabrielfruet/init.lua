return {
    "xiyaowong/transparent.nvim",
    priority=100,
    config = function()
        require('transparent').setup {
            extra_groups = {
                "NeoTreeNormal",
                "NeoTreeNormalNC",
                "NormalFloat",
            },
        }
    end,
}
