local filetype = require('plenary.filetype')
local popup = require('plenary.popup')

local lang_command = {
    rust = function() return 'cargo run' end;
    python = function(fname) return ('python ' .. fname) end;
}

local function get_lang(filepath)
    local lang = filetype.detect_from_extension(filepath)
    if lang == '' then
        lang = 'Non existing extension.'
    end
    return lang
end

local function get_command(filepath, lang)
    local create_command = lang_command[lang]
    if create_command == nil then
        return nil
    end
    return create_command(filepath)
end

local function buf_on_output(bufnr)
    return  function (chan_id, data, name)
        if data then
            vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
        end
    end
end

local function autorun()
    local filepath = vim.fn.expand('%:p')
    local language = get_lang(filepath)
    local command = get_command(filepath, language)
    local output
    if command ~= nil then
        output = vim.fn.systemlist(command)
    else
        output = "No binding for this language: " .. language
    end


    if command == nil then
        local vim_options = {
            relative = "cursor",
            border = {1,2,1,2},
            padding = {2, 2, 2, 2},
            highlight = 'ErrorMsg',
            cursorline = false,
            enter = true,
            focusable = true,
        }

        -- Show the popup at the cursor position
        local popup_id = popup.create(output, vim_options)
        local popup_bufnr = vim.fn.bufnr(vim.fn.winbufnr(popup_id))

        -- Define a key mapping for "q" in the buffer
        local opts = { noremap = true, silent = true, nowait = true }
        vim.api.nvim_buf_set_keymap(popup_bufnr, 'n', 'q', '<cmd>close<CR>', opts)
        vim.api.nvim_buf_set_keymap(popup_bufnr, 'n', '<CR>', '<cmd>close<CR>', opts)
        return
    end

    if type(output) == 'table' then
        local fname = vim.fn.expand('%:t')
        local buf_name = get_lang(filepath) .. ' ' .. fname
        local bufnr = vim.api.nvim_create_buf(false, true)
        local on_output = buf_on_output(bufnr)

        local job_id = vim.fn.jobstart(command, {
            on_stdout = on_output,
            on_stderr = on_output,
            on_exit = function(id, code, event)
                print("Job completed with exit code:", code)
            end,
            stdout_buffered = true,
            stderr_buffered = true,
        })
        local win_width = vim.api.nvim_win_get_width(0)
        local win_height = vim.api.nvim_win_get_height(0)
        local height = math.floor(win_height * 0.5)
        local width = math.floor(win_width * 0.5)

        local col = math.floor((win_width - width )/2)
        local row = math.floor((win_height - height )/2)
        print(col,row)

        local winopts = {
            title=buf_name,
            relative='win',
            width=width,
            height=height,
            col=col,
            row=row,
            anchor='NW',
            style='minimal',
            border='rounded'
        }
        vim.api.nvim_open_win(bufnr, true, winopts)
        --vim.api.nvim_buf_set_lines(bufnr,0,-1,false, output)

        vim.bo.bufhidden = "delete"
        vim.bo.readonly = true
        vim.api.nvim_buf_set_name(bufnr, buf_name)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', ':bd!<CR>', { noremap = true, silent = true })
        --vim.fn.jobwait({job_id})
        --vim.cmd([[highlight RunMessage guifg=#00afff]])

        -- Display the message in the status line
        --vim.api.nvim_buf_set_option(bufnr, 'buftype', 'nofile')
        --vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, { "Press 'q' to close this buffer" })
        --local last_line = vim.api.nvim_buf_line_count(0) - 1
        --vim.api.nvim_buf_add_highlight(bufnr, -1, 'RunMessage', last_line, 0, -1)
    end
end


return {
    run = function ()
        vim.api.nvim_create_user_command('AutoRun', function() autorun() end, {})
        vim.keymap.set("n", "<c-r>", autorun , {noremap=true})
    end
}

