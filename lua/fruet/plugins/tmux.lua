return {
    "aserowy/tmux.nvim",
    enabled=true,
    config = function ()
        require('tmux').setup({
            copy_sync = {
                enable = false
            },
        })
    end
}
