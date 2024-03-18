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

local function run()
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
        print(fname)
        vim.api.nvim_command("enew")
        vim.api.nvim_buf_set_lines(0,0,-1,false, output)

        vim.bo.bufhidden = "delete"
        vim.api.nvim_buf_set_name(0, get_lang(filepath) .. ' ' .. fname)
        vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':bd!<CR>', { noremap = true, silent = true })
        vim.cmd([[highlight RunMessage guifg=#00afff]])

        -- Display the message in the status line
        vim.api.nvim_buf_set_option(0, 'buftype', 'nofile')
        vim.api.nvim_buf_set_lines(0, -1, -1, false, { "Press 'q' to close this buffer" })
        local last_line = vim.api.nvim_buf_line_count(0) - 1
        vim.api.nvim_buf_add_highlight(0, -1, 'RunMessage', last_line, 0, -1)
    end
end

vim.api.nvim_create_user_command('AutoRun', function() run() end, {})

return {
    run = run
}

