return {
   "lervag/vimtex",
    enabled=true,
    init = function()
        -- Use init for configuration, don't use the more common "config".
        vim.g.vimtex_view_method = 'zathura'
        vim.g.vimtex_compiler_method = 'latexmk'
        vim.g.vimtex_quickfix_mode = 0

        local only_clear = {clear=true}
        local vimtex_keyamps_on_tex = vim.api.nvim_create_augroup('vimtex_keymaps_on_tex', only_clear)
        vim.api.nvim_create_autocmd({'BufNew', 'BufEnter'}, {
            pattern="*.tex",
            group=vimtex_keyamps_on_tex,
            callback=function ()
                local bufnr = vim.api.nvim_get_current_buf()
                vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>sc', '<CMD>VimtexCompile<CR>', {noremap=true})
            end
        })

    end
}
