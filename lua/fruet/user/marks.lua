local M = {}

local dsutils = require('fruet.utils.ds')
local hlutils = require('fruet.utils.hl')

local lclet = {}
local uclet = {}
local allet = {}

for i = string.byte('a'), string.byte('z') do
    table.insert(lclet, i)
    table.insert(allet, i)
end

-- Populate the table with ASCII codes for A to Z
for i = string.byte('A'), string.byte('Z') do
    table.insert(uclet, i)
    table.insert(allet, i)
end

---@class Mark
---@field bufnr integer
---@field lnum integer
---@field cnum integer
---@field register string
local Mark = {}

function Mark:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

---@return integer[]
function Mark:cursor()
    return {self.lnum, self.cnum}
end

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
        M.globalmarks[i] = Mark:new({
            bufnr=bufnr,
            lnum=mark[1],
            cnum=mark[2],
            register=string.char(i),
        })

        vim.fn.sign_place(i, 'bookmarks', 'Mark ' .. i, bufnr, {lnum=mark[1], priority=100})
    end


    local bufnr = vim.api.nvim_get_current_buf()
    for _, i in pairs(uclet) do
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
        M.localmarks[bufnr][i] = nil
    end
    local function add_mark_sign(i, bufnr, mark)
        if M.localmarks[bufnr] ~= nil and M.localmarks[bufnr][i] ~= nil then
            rmv_mark_sign(i, bufnr)
        end
        M.localmarks[bufnr][i] = Mark:new({
            bufnr=bufnr,
            lnum=mark[1],
            cnum=mark[2],
            register=string.char(i),
        })
        vim.fn.sign_place(i, 'bookmarks', 'Mark ' .. i, bufnr, {lnum=mark[1], priority=100})
    end

    local bufnr = vim.api.nvim_get_current_buf()
    for _, i in pairs(allet) do
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

    for _, mark in pairs(marks) do
        -- i think this is 0-indexing
        local content = vim.api.nvim_buf_get_lines(bufnr, mark.lnum-1, mark.lnum, true)[1]
        table.insert(list, {
            bufnr = mark.bufnr,
            module = ' ' .. mark.register .. ' ',
            lnum = mark.lnum,
            col = mark.cnum,
            text = content,
        })
    end
    vim.fn.setloclist(winnr, {}, ' ', {items=list})
    vim.cmd[[lopen]]
end

local function show_local_marks2()
    local bufnr = vim.api.nvim_get_current_buf()
    local winnr = vim.api.nvim_get_current_win()
    local marks_by_mark = M.localmarks[bufnr]
    local marks = {}
    for _, mark in pairs(marks_by_mark) do
        table.insert(marks, mark)
    end

    table.sort(marks, function (a,b)
        return a.lnum < b.lnum
    end)

    local n = 0
    for _, mark in pairs(marks) do if mark ~= nil then n = n + 1 end end
    if n == 0 then
        vim.api.nvim_err_write('No available marks for this buffer')
        return
    end

    local list = {}

    local win_width = vim.api.nvim_win_get_width(0)
    local win_height = vim.api.nvim_win_get_height(0)

    local height = 10
    local width = 50

    local row = 0
    local col = win_width

    local winopts = {
        relative='win',
        win=winnr,
        width=width,
        height=height,
        col=col,
        row=0,
        style='minimal',
        border='rounded'
    }

    local float_bufnr = vim.api.nvim_create_buf(false, true)
    local augroup = vim.api.nvim_create_augroup('ShowLocalMarks', {clear=true})

    vim.keymap.set('n', 'q', function()
        vim.api.nvim_buf_delete(float_bufnr, {})
    end, { noremap = true, silent = true, buffer=float_bufnr})

    local winhan = vim.api.nvim_open_win(float_bufnr, true, winopts)

    vim.api.nvim_set_option_value('bufhidden', "delete", {buf=float_bufnr})
    vim.api.nvim_set_option_value('wrap',false, {win=winhan})

    ---@type table<string, integer>
    local marks_float_idx_by_char = {}

    for i, mark in ipairs(marks) do
        marks_float_idx_by_char[mark.register] = i
    end

    local function handle_mark(char)
        local line = marks_float_idx_by_char[char]
        vim.api.nvim_win_set_cursor(winhan, {line,0})
    end

    vim.api.nvim_set_keymap('n', "'", [[:lua _G.my_marks.capture_mark()<CR>]], { noremap = true, silent = true })

    _G.my_marks = {}

    function _G.my_marks.capture_mark()
        local char = vim.fn.getcharstr()
        handle_mark(char)
    end


    local ns_id = vim.api.nvim_create_namespace("mark_selected_highlight")

    ---@type Mark[]
    local line_mark_map = {}

    for _, mark in pairs(marks) do
        -- i think this is 0-indexing
        local content = vim.api.nvim_buf_get_lines(bufnr, mark.lnum-1, mark.lnum, true)[1]
        local extmarks = vim.api.nvim_buf_get_extmarks(bufnr, -1, {mark.lnum-1,0},{mark.lnum-1,-1}, {overlap=true, details=true, type="highlight"})
        local i = #line_mark_map
        local placehold_mark_text = '\'' .. mark.register .. ' | '
        local pad = #placehold_mark_text
        vim.api.nvim_buf_set_lines(float_bufnr, i, i+1, false, {placehold_mark_text .. content})
        vim.api.nvim_buf_add_highlight(float_bufnr, ns_id, '@text.warning', i, 1, 2)
        for _, hldetails in pairs(hlutils.buf_get_ts_highlights(bufnr, mark.lnum)) do
            local start_col, end_col, hl_group = table.unpack(hldetails)
            vim.api.nvim_buf_add_highlight(float_bufnr, ns_id, hl_group, i, start_col+pad, end_col+pad)
        end
        table.insert(line_mark_map, mark)
    end

    local last_hl_mark = line_mark_map[1]

    vim.api.nvim_create_autocmd('CursorMoved', {
        group=augroup,
        buffer=float_bufnr,
        callback=function ()
            vim.api.nvim_buf_clear_namespace(bufnr, ns_id, last_hl_mark.lnum-1, last_hl_mark.lnum)
            local cursor = vim.api.nvim_win_get_cursor(winhan)
            local selected_line = cursor[1]
            local mark = line_mark_map[selected_line]
            last_hl_mark = mark
            vim.api.nvim_win_set_cursor(winnr, mark:cursor())
            local hl_id = vim.api.nvim_buf_add_highlight(bufnr, ns_id, "Visual", mark.lnum-1, 0, -1)
        end
    })

    vim.api.nvim_create_autocmd('BufLeave', {
        group=augroup,
        buffer=float_bufnr,
        callback=function ()
            vim.api.nvim_win_close(winhan, true)
            vim.api.nvim_buf_delete(float_bufnr, {force=true})
            vim.api.nvim_buf_clear_namespace(bufnr, ns_id, last_hl_mark.lnum-1, last_hl_mark.lnum)
        end
    })

    vim.api.nvim_set_option_value('modifiable',false, {buf=float_bufnr})
end

function M.run()
    ---@type table<integer,  Mark>
    M.globalmarks = {}
    ---@type table<integer, table<integer, Mark>>
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
    vim.api.nvim_create_user_command("ShowLocalMarks", show_local_marks2, {})
    vim.keymap.set('n', 'm?', show_local_marks2, {})

end

return M
