local function run()
    local only_clear = {clear=true}
    local highlighted_yank_group = vim.api.nvim_create_augroup('highlighted_yank_group', only_clear)
    vim.api.nvim_create_autocmd('TextYankPost', {
        group=highlighted_yank_group,
        callback=function ()
            vim.highlight.on_yank{higroup = 'IncSearch', timeout='1000'}
        end
    })
end

return {
    run=run
}

