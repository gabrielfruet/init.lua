local function run()
    local only_clear = {clear=true}
    local highlighted_yank_group = vim.api.nvim_create_augroup('highlighted_yank_group', only_clear)
    vim.api.nvim_create_autocmd('TextYankPost', {
        group=highlighted_yank_group,
        callback=function ()
            vim.highlight.on_yank{higroup = 'IncSearch', timeout='1000'}
        end
    })
    -- Function to switch to a buffer by number
    local function switch_to_buffer(bufnr)
        if vim.fn.bufexists(bufnr) == 1 then
            vim.api.nvim_set_current_buf(bufnr)
        else
            vim.api.nvim_err_writeln("Buffer " .. bufnr .. " doesn't exist")
        end
    end

    -- Function to create a keybinding for a buffer
    local function create_buffer_keybind(bufnr)
        local key = tostring(bufnr)
        vim.keymap.set('n', '<leader>' .. key, function()
            switch_to_buffer(bufnr)
        end, { noremap = true, silent = true, desc = "Switch to buffer " .. key })
    end

    -- Set up autocmd to create keybindings for new buffers
    vim.api.nvim_create_autocmd("BufAdd", {
        callback = function(ev)
            local bufnr = ev.buf
            create_buffer_keybind(bufnr)
        end
    })

    -- Create keybindings for existing buffers
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        create_buffer_keybind(bufnr)
    end
end

return {
    run=run
}

