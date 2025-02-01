local M = {}

-- #TODO change the 'widgets' code to a separate file

local stline = require('fruet.user.statusline')
local nvim_web_dev_get_icon = require'nvim-web-devicons'.get_icon

local function hl_wrapper(hl)
    return function (text)
        return string.format('%%#%s#%s', hl, text)
    end
end

--- FRECENCY
--- @class FrecencyBuffer
--- @field recentness number
--- @field frequency number
--- @field edit_frequency number
--- @field initial_bonus number
---
--- @type table<integer, FrecencyBuffer>
local frecency = {}

local function is_useful_buffer(bufnr)
    -- Get buffer info
    local buftype = vim.bo[bufnr].buftype
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    local listed = vim.bo[bufnr].buflisted
    local win_config = vim.api.nvim_win_get_config(0)

    -- Exclude quickfix (name-based check)
    if bufname:match("^quickfix%-%d+$") then
        return false
    end

    -- Ignore floating windows (fixes nvim-cmp popups)
    if win_config.relative ~= "" then
        return false
    end

    -- Allow only listed buffers (ignores scratch and temp buffers)
    if not listed then
        return false
    end

    -- Ignore empty unnamed buffers
    if bufname == "" then
        return false
    end

    -- Allow only normal files and user-created buffers
    return buftype == "" or buftype == "nofile"
end

local function update_frecency(bufnr, edit)
    edit = edit and 0 or 1
    if not frecency[bufnr] then
        return
    end
    for ibufnr, buf in pairs(frecency) do
        if ibufnr == bufnr then
            buf.recentness = buf.recentness * 0.9 + 1  -- Recentness update (decay + boost)
            buf.frequency = buf.frequency * 0.9+ 1          -- Usage count
            buf.initial_bonus = buf.initial_bonus * 0.8 -- Decay initial bonus gradually
            buf.edit_frequency = buf.edit_frequency * 0.9 + edit
        else
            buf.recentness = buf.recentness * 0.9  -- Recentness update (decay + boost)
            buf.frequency = buf.frequency * 0.9          -- Usage count
            buf.initial_bonus = buf.initial_bonus * 0.8 -- Decay initial bonus gradually
            buf.edit_frequency = buf.edit_frequency * 0.9
        end
    end
end

local function add_frecency_buffer(bufnr)
    if not frecency[bufnr] then
        frecency[bufnr] = {
            recentness = 1.0,  -- Starts at max, decays over time
            frequency = 1,     -- Starts at 1, increases per use
            initial_bonus = 2.0, -- A boost for new buffers, but it decays
            edit_frequency = 1,
        }
    end
end


local function calculate_score(bufnr)
    local buf = frecency[bufnr]
    if not buf then return -math.huge end -- Lowest priority for unknown buffers

    local W1, W2, W3, W4 = 3.0, 1.0, 0.5, 2.0  -- Weights for tuning
    local score = W1 * buf.recentness +
        W2 * math.sqrt(buf.frequency) +
        W3 * buf.initial_bonus +
        W4 * buf.edit_frequency
    return score
end

local function sorted_buffers()
    local buffers = vim.fn.getbufinfo({buflisted=true})
    local bufnrs = {}

    for _, bufhan in pairs(buffers) do
        table.insert(bufnrs, bufhan.bufnr)
    end

    table.sort(bufnrs, function(a, b)
        return calculate_score(a) > calculate_score(b)
    end)
    return bufnrs
end

local function setup_frecency()
    vim.api.nvim_create_autocmd("BufAdd", {
        callback = function ()
            local bufnr = vim.api.nvim_get_current_buf()
            add_frecency_buffer(bufnr)
            vim.cmd[[redrawtabline]]
        end
    })
    vim.api.nvim_create_autocmd("BufAdd", {
        callback = function ()
            local bufnr = vim.api.nvim_get_current_buf()
            add_frecency_buffer(bufnr)
            vim.cmd[[redrawtabline]]
        end
    })
    vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
            local bufnr = vim.api.nvim_get_current_buf()
            update_frecency(bufnr)
            vim.cmd[[redrawtabline]]
        end
    })
end

_G._sorted_buffers = sorted_buffers

---- FRECENCY END

local function my_tab_line()
    local s = ""
    local buffers = sorted_buffers()

    for i, buf in ipairs(buffers) do
        local bufnr = buf
        local bufnrhl
        local tablinehl
        local symbhl
        local is_selected = bufnr == vim.fn.bufnr('%')

        -- Select the highlighting
        if is_selected then
            tablinehl = hl_wrapper('TabLineSel')
            bufnrhl = hl_wrapper('TabLineBufNumSel')
            symbhl = hl_wrapper('TabLineSelSymbol')
        else
            tablinehl = hl_wrapper('TabLine')
            bufnrhl = hl_wrapper('TabLineBufNum')
            symbhl = hl_wrapper('TabLineSymbol')
        end

        local bufname = vim.fn.bufname(bufnr)
        local buf_rank = i or '?'
        local dispname = vim.fn.fnamemodify(bufname, ':t')
        local extension = vim.fn.fnamemodify(bufname, ':e')

        if dispname == "" then
            dispname = "[No Name]"
        end

        local unsaved_icon = vim.api.nvim_get_option_value('modified',{buf=bufnr}) and '*' or ''
        local icon = nvim_web_dev_get_icon(dispname, extension, {default=true})
        local symbr = ''
        local symbl = ''
        s = string.format("%s%s %s %s %%*", s,  bufnrhl(' ' .. buf_rank .. unsaved_icon), tablinehl(icon), tablinehl(dispname))
    end

    -- After the last buffer, fill with TabLineFill
    s = s .. "%#TabLineFill#%T"

    -- Right-align the label to close the current buffer
    if #buffers > 1 then
        s = s .. '%=%#TabLine#%999X'
    end

    return s
end

_G._mytabline = my_tab_line

local hlutils = require('fruet.utils.hl')

local function set_hls()
    local colors_tblsel = hlutils.get_highlight_color('TabLineSel')
    local colors_kw = hlutils.get_highlight_color('Keyword')
    local base_fg = vim.g.foreground
    vim.api.nvim_set_hl(0, 'TabLineBufNumSel', { bg = colors_tblsel.bg, fg = base_fg, bold=true, italic=true})
    vim.api.nvim_set_hl(0, 'TabLineBufNum', { fg = base_fg, bg = "none", bold=true})
    vim.api.nvim_set_hl(0, 'TabLineCwd', { bg = "none", fg = colors_kw.fg, italic=true})

end

local function current_working_directory()
    local cwd = vim.fn.getcwd()
    local home = vim.fn.expand('~')

    if string.find(cwd, home, 1, true) == 1 then
      cwd = '~' .. string.sub(cwd, #home + 1)
    end

    return table.concat{
        '%#TabLineCwd#',
        '[',
        cwd,
        ']'
    }
end

local function tabs_widget()
    local s = " "
    local tabs = vim.api.nvim_list_tabpages()
    local ctabnr = vim.api.nvim_get_current_tabpage()

    if #tabs == 1 then
        return ""
    end

    for i, tabnr in ipairs(tabs) do
        local is_selected = tabnr == ctabnr
        local tabnrhl
        local symbhl

        -- Select the highlighting
        if is_selected then
            tabnrhl = hl_wrapper('TabLineTabSel')
            symbhl = hl_wrapper('TabLineTabSymbolSel')
        else
            tabnrhl = hl_wrapper('TabLineBufNum')
            symbhl = hl_wrapper('TabLineBufNUm')
        end


        s = string.format("%s %s %%*", s,  tabnrhl(tabnr))
    end
    return s
end


_G._cwd = current_working_directory
_G._tabs = tabs_widget


local function tabline_lhs()
    return table.concat{
        '%{%v:lua._get_mode()%}',
        '%{%v:lua._docker()%}',
        '%{%v:lua._branch_name()%}',
        '',
        '%<',
        '%{%v:lua._tabs()%}',
        '%*',
    }
end

local function tabline()
    return table.concat{
        tabline_lhs(),
        '%{%v:lua._mytabline()%}',
        --'%=',
        --'%{%v:lua._cwd()%}'

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
    setup_frecency()
end

return M
