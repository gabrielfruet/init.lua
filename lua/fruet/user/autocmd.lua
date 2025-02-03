local function run()
    vim.api.nvim_create_autocmd('TextYankPost', {
        group=vim.api.nvim_create_augroup('highlighted_yank_group', {clear=true}),
        callback=function ()
            vim.highlight.on_yank{higroup = 'IncSearch', timeout=1000}
        end
    })

    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'qf',
        callback = function()
            vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':cclose<CR>:lclose<cr>', { noremap = true, silent = true })
        end
    })

    local function switch_to_buffer(bufrank)
        -- Check if the buffer exists
        local buffers = _G._sorted_buffers()
        vim.print(buffers)
        local bufnr = buffers[bufrank]
        if bufnr == nil then return end
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

