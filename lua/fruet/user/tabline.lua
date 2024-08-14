local M = {}

local buf_to_virtbuf_map = {}
local virtbuf_to_buf_map = {}

_G.virtbuf_to_buf_map = virtbuf_to_buf_map

local stline = require('fruet.user.statusline')
local nvim_web_dev_get_icon = require'nvim-web-devicons'.get_icon

local function hl_wrapper(hl)
    return function (text)
        return string.format('%%#%s#%s', hl, text)
    end
end

function MyTabLine()
    local s = ""
    local buffers = vim.fn.getbufinfo({buflisted = 1}) -- Get all listed buffers

    for _, buf in ipairs(buffers) do
        local bufnr = buf.bufnr
        local bufnrhl
        local tablinehl
        local symbhl

        -- Select the highlighting
        if bufnr == vim.fn.bufnr('%') then
            tablinehl = hl_wrapper('TabLineSel')
            bufnrhl = hl_wrapper('TabLineBufNumSel')
            symbhl = hl_wrapper('TabLineSelSymbol')
        else
            tablinehl = hl_wrapper('TabLine')
            bufnrhl = hl_wrapper('TabLineBufNum')
            symbhl = hl_wrapper('TabLineSymbol')
        end

        local bufname = vim.fn.bufname(bufnr)
        local virtbuf = buf_to_virtbuf_map[bufnr] or '?'
        local dispname = vim.fn.fnamemodify(bufname, ':t')
        local extension = vim.fn.fnamemodify(bufname, ':e')

        if bufname == "" then
            dispname = "[No Name]"
        end
        local unsaved_icon = vim.api.nvim_get_option_value('modified',{buf=bufnr}) and '*' or ''
        local icon = nvim_web_dev_get_icon(dispname, extension, {default=true})
        local symbr = ''
        local symbl = ''
        s = string.format("%s%s %s %s %%*", s,  bufnrhl(' ' .. virtbuf .. unsaved_icon), tablinehl(icon), tablinehl(dispname))
    end

    -- After the last buffer, fill with TabLineFill
    s = s .. "%#TabLineFill#%T"

    -- Right-align the label to close the current buffer
    if #buffers > 1 then
        s = s .. '%=%#TabLine#%999X'
    end

    return s
end

_G._mytabline = MyTabLine

local hlutils = require('fruet.utils.hl')

local function set_hls()
    local colors_tblsel = hlutils.get_highlight_color('TabLineSel')
    local colors_kw = hlutils.get_highlight_color('Keyword')
    local base_fg = vim.g.foreground
    vim.api.nvim_set_hl(0, 'TabLineBufNumSel', { bg = colors_tblsel.bg, fg = base_fg, bold=true, italic=true})
    vim.api.nvim_set_hl(0, 'TabLineBufNum', { fg = base_fg, bg = "none", bold=true})

end

local function table_size(table)
    local n = 0
    for k, v in pairs(table) do
        n = n + 1
    end
    return n
end


local function setup_virtbuf()
    local update_virtbuf = vim.api.nvim_create_augroup('update_virtbuf', {clear=true})
    local virtbuf_availables = {}
    local function virtbuf_append(bufnr)
        local idx = table_size(buf_to_virtbuf_map) + table_size(virtbuf_availables) + 1
        local i_idx = -1

        for i,avail_idx in ipairs(virtbuf_availables) do
            if avail_idx < idx then
                idx = avail_idx
                i_idx = i
            end
        end

        if i_idx ~= -1 then
            table.remove(virtbuf_availables, i_idx)
        end

        buf_to_virtbuf_map[bufnr] = idx
        virtbuf_to_buf_map[idx] = bufnr

    end

    local function turn_virtbuf_to_available(bufnr)
        local virtbufnr = buf_to_virtbuf_map[bufnr]
        if virtbufnr == nil then
            return
        end
        table.insert(virtbuf_availables, virtbufnr)

        buf_to_virtbuf_map[bufnr] = nil
        virtbuf_to_buf_map[virtbufnr] = nil

    end

    vim.api.nvim_create_autocmd('BufAdd', {
        group=update_virtbuf,
        callback=function ()
            local bufnr = tonumber(vim.fn.expand("<abuf>"))
            if bufnr == nil then
                return
            end
            virtbuf_append(bufnr)
        end
    })

    vim.api.nvim_create_autocmd('BufDelete', {
        group=update_virtbuf,
        callback=function ()
            local bufnr = tonumber(vim.fn.expand("<abuf>"))
            if bufnr == nil then
                return
            end
            turn_virtbuf_to_available(bufnr)
        end
    })

    vim.api.nvim_create_autocmd('VimEnter', {
        group=update_virtbuf,
        callback=function ()
            local bufnrlist = vim.fn.getbufinfo({buflisted=1})

            for _, buf in ipairs(bufnrlist) do
                local bufnr = buf.bufnr
                virtbuf_append(bufnr)
            end
        end
    })

end

local function tabline()
    return table.concat{
        '%{%v:lua._get_mode()%}',
        '%{%v:lua._branch_name()%}',
        '%{%v:lua._mytabline()%}',
    }
end

_G._tabline = tabline

local function setup_tabline()
    vim.opt.showtabline = 2
    vim.opt.tabline = '%!v:lua._tabline()'
    vim.api.nvim_create_autocmd('ModeChanged', {
        group=vim.api.nvim_create_augroup('redraw_tabline', {clear=true}),
        callback=function ()
            vim.cmd"redrawtabline"
        end
    })
end

function M.run()
    set_hls()
    setup_tabline()
    setup_virtbuf()
end

return M
