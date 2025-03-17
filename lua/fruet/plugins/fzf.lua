return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        -- calling `setup` is optional for customization
        require("fzf-lua").setup({
            keymap = {
                fzf = {
                    ["ctrl-q"] = "select-all+accept",
                },
            },
        })
        local fzf = require("fzf-lua")
        vim.keymap.set('n', '<C-p>', fzf.files, {noremap=true})
        vim.keymap.set('n', '<C-f>', fzf.builtin, {noremap=true})
        vim.keymap.set('n', '<C-g>', fzf.live_grep, {noremap=true})
        vim.keymap.set('n', '<leader>ws', fzf.lsp_live_workspace_symbols, {noremap=true})
        vim.keymap.set('n', '<leader>lr', fzf.lsp_references, {noremap=true})
    end
}
