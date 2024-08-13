local function run()
    vim.api.nvim_create_autocmd('TextYankPost', {
        group=vim.api.nvim_create_augroup('highlighted_yank_group', {clear=true}),
        callback=function ()
            vim.highlight.on_yank{higroup = 'IncSearch', timeout='1000'}
        end
    })

    local function switch_to_buffer(virtbuf)
        -- Check if the buffer exists
        local bufnr = _G.virtbuf_to_buf_map[virtbuf]
        if vim.fn.bufexists(bufnr) == 1 then
            vim.api.nvim_set_current_buf(bufnr)
        else
            vim.api.nvim_err_writeln("Buffer " .. bufnr .. " doesn't exist")
        end
    end

    -- Set up keymaps for buffer switching
    for i = 0, 9 do
        vim.keymap.set('n', string.format('<leader>%d', i), function()
            switch_to_buffer(i)
        end, { noremap = true, silent = true, desc = string.format("Switch to buffer %d", i) })
    end
end

return {
    run=run
}

