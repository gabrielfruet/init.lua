local buf = vim.api.nvim_get_current_buf()
local fpath_wo_extension = vim.fn.expand('%:r')

local kset = vim.keymap.set

kset('n', '<leader>zo', function ()
    vim.fn.jobstart(string.format('zathura %s.pdf', fpath_wo_extension), {detach=true})
end, {
        buffer=buf,
        noremap=true,
    })


local hot_reload = false

kset('n', '<leader>hr', function ()
    hot_reload = true
end, {
        buffer=buf,
        noremap=true,
    })

kset('n', '<leader>shr', function ()
    hot_reload = true
end, {
        buffer=buf,
        noremap=true,
    })

vim.api.nvim_create_autocmd('BufWritePost', {
    group=vim.api.nvim_create_augroup('hot_reload_to_pandoc', {clear=true}),
    callback=function ()
        if not hot_reload then return end

        vim.fn.jobstart(string.format('pandoc %s.md -o %s.pdf', fpath_wo_extension, fpath_wo_extension), {detach=true})
    end
})
