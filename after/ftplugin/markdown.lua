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

kset('n', '<leader>re', function ()
    hot_reload = true
    vim.print("Hot reload enabled")
end, {
        buffer=buf,
        noremap=true,
    })

kset('n', '<leader>rs', function ()
    hot_reload = true
    vim.print("Hot reload disabled")
end, {
        buffer=buf,
        noremap=true,
    })

local function stder_handler(cmd)
    return function (job_id, data, event)
        -- Check if there's any data in the stderr output
        if data and #data > 1 then
            -- Join the data array (it may come in chunks) and print to the user
            local error_message = table.concat(data, "\n")
            -- Print the error message
            vim.api.nvim_err_writeln("Error from \'" .. cmd .. "\' " .. job_id .. ": " .. error_message)
        end
    end
end

vim.api.nvim_create_autocmd('BufWritePost', {
    group=vim.api.nvim_create_augroup('hot_reload_to_pandoc', {clear=true}),
    callback=function ()
        if not hot_reload then return end
        local cmd = string.format('pandoc %s.md -o %s.pdf', fpath_wo_extension, fpath_wo_extension)
        vim.fn.jobstart(cmd, {
            detach=true,
            on_stderr=stder_handler(cmd)
        })
    end
})

vim.opt_local.foldmethod = 'expr'
vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
