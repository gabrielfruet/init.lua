_G.pandoc_buffers = _G.pandoc_buffers or {}

local buf = vim.api.nvim_get_current_buf()
local fpath_wo_extension = vim.fn.expand('%:r')

local kset = vim.keymap.set
local hot_reload = false

kset('n', '<leader>zo', function ()
    vim.fn.jobstart(string.format('zathura %s.pdf', fpath_wo_extension), {detach=true})
end, {
        buffer=buf,
        noremap=true,
    })


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

local function generate_toc_quickfix()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local quickfix_list = {}

    for i, line in ipairs(lines) do
        local level, header = line:match("^(#+)%s+(.*)")
        if level and header then
            local indent_level = string.rep("  ", #level - 1)
            table.insert(quickfix_list, {
                bufnr = 0,
                lnum = i + 1,
                col = 1,
                text = indent_level .. header,
            })
        end
    end

    if #quickfix_list > 0 then
        vim.fn.setqflist(quickfix_list, "r")
        vim.cmd("copen")
    else
        print("No headers found to create Table of Contents.")
    end
end

vim.api.nvim_create_user_command("PandocToc", generate_toc_quickfix, {})

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
    buffer=buf,
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
