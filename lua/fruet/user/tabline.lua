local M = {}

local icons_by_extension = require'nvim-web-devicons'.get_icons_by_extension()

local function hl_wrapper(hl)
    return function (text)
        return string.format('%%#%s#%s', hl, text)
    end
end

function MyTabLine()
    local s = ""
    local buffers = vim.fn.getbufinfo({buflisted = 1}) -- Get all listed buffers

    for _, buf in ipairs(buffers) do
        local bufnum = buf.bufnr
        local bufnumhl
        local tablinehl

        -- Select the highlighting
        if bufnum == vim.fn.bufnr('%') then
            tablinehl = hl_wrapper('TabLineSel')
            bufnumhl = hl_wrapper('TabLineBufNumSel')
        else
            tablinehl = hl_wrapper('TabLine')
            bufnumhl = hl_wrapper('TabLineBufNum')
        end

        local bufname = vim.fn.bufname(bufnum)
        local dispname = vim.fn.fnamemodify(bufname, ':t')
        local extension = vim.fn.fnamemodify(bufname, ':e')

        if bufname == "" then
            dispname = "[No Name]"
        end
        -- idiomatic way of getting the icon as the tbl can be nil
        local icon = icons_by_extension[extension] and icons_by_extension[extension].icon or ''
        s = string.format("%s%s %s %s %%*", s, bufnumhl(' ' .. bufnum), tablinehl(icon), tablinehl(dispname))
    end

    -- After the last buffer, fill with TabLineFill
    s = s .. "%#TabLineFill#%T"

    -- Right-align the label to close the current buffer
    if #buffers > 1 then
        s = s .. '%=%#TabLine#%999X'
    end

    vim.print(s)

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

function M.run()
    set_hls()
    vim.opt.showtabline = 2
    vim.opt.tabline = '%{%v:lua._mytabline()%}'
end

return M
