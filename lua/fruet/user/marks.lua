local M = {}

local dsutils = require('fruet.utils.ds')

local function define_az_marks()
    for i = string.byte('a'), string.byte('z') do
        vim.fn.sign_define('Mark ' .. i, {text=string.char(i)})
    end
end

local function define_AZ_marks()
    for i = string.byte('A'), string.byte('Z') do
        vim.fn.sign_define('Mark ' .. i, {text=string.char(i)})
    end
end

local function update_global_marks_buffer()
    local function rmv_mark_sign(i, bufnr)
        vim.fn.sign_unplace('bookmarks', {buffer=bufnr, id=i})
        M.globalmarks[i] = nil
    end
    local function add_mark_sign(i, bufnr, mark)
        if M.globalmarks[i] ~= nil then
            rmv_mark_sign(i, bufnr)
        end
        M.globalmarks[i] = bufnr
        vim.fn.sign_place(i, 'bookmarks', 'Mark ' .. i, bufnr, {lnum=mark[1], priority=100})
    end


    local bufnr = vim.api.nvim_get_current_buf()
    for i = string.byte('A'), string.byte('Z') do
        local mark = vim.api.nvim_buf_get_mark(0, string.char(i))
        if mark[1] ~= 0 then
            add_mark_sign(i,bufnr,mark)
        else
            rmv_mark_sign(i,bufnr)
        end
    end
end


local function update_local_marks_buffer()
    local function rmv_mark_sign(i, bufnr)
        local ret = vim.fn.sign_unplace('bookmarks', {buffer=bufnr, id=i})
        if ret == 0 and M.localmarks[bufnr] ~= nil then
            M.localmarks[bufnr][i] = nil
        end
    end
    local function add_mark_sign(i, bufnr, mark)
        if M.localmarks[bufnr] ~= nil and M.localmarks[bufnr][i] ~= nil then
            rmv_mark_sign(i, bufnr)
        end
        M.localmarks[bufnr] = M.localmarks[bufnr] or {}
        M.localmarks[bufnr][i] = mark
        vim.fn.sign_place(i, 'bookmarks', 'Mark ' .. i, bufnr, {lnum=mark[1], priority=100})
    end

    local bufnr = vim.api.nvim_get_current_buf()
    for i = string.byte('a'), string.byte('z') do
        local mark = vim.api.nvim_buf_get_mark(0, string.char(i))
        if mark[1] ~= 0 then
            add_mark_sign(i,bufnr,mark)
        else
            rmv_mark_sign(i,bufnr)
        end
    end
end

local function show_local_marks()
    local bufnr = vim.api.nvim_get_current_buf()
    local winnr = vim.api.nvim_get_current_win()
    local marks = M.localmarks[bufnr]

    local list = {}

    for i, mark in pairs(marks) do
        local lnum  = mark[1]
        local content = vim.api.nvim_buf_get_lines(bufnr, lnum, lnum+1, true)[1]
        table.insert(list, {
            bufnr = bufnr,
            module = ' ' .. string.char(i) .. ' ',
            lnum = lnum,
            col = mark[2],
            -- text = "Local mark '" .. string.char(i) .. "'",
            text = content,
        })
    end
    vim.fn.setloclist(winnr, {}, ' ', {items=list})
    vim.cmd[[lopen]]
end

function M.run()
    M.globalmarks = {}
    M.localmarks = dsutils.DefaultTable:new()

    define_az_marks()
    define_AZ_marks()

    vim.api.nvim_create_autocmd({'BufEnter', 'CursorMoved'}, {
        group=vim.api.nvim_create_augroup('AddLocalMarkToBuffer', {clear=true}),
        callback=update_local_marks_buffer
    })
    vim.api.nvim_create_autocmd({'BufEnter', 'CursorMoved'}, {
        group=vim.api.nvim_create_augroup('AddGlobalMarkToBuffer', {clear=true}),
        callback=update_global_marks_buffer
    })
    vim.api.nvim_create_user_command("ShowLocalMarks", show_local_marks, {})

end

return M
