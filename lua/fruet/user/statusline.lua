local M = {}


local mode_map = {
  ['n']      = 'NORMAL',
  ['no']     = 'O-PENDING',
  ['nov']    = 'O-PENDING',
  ['noV']    = 'O-PENDING',
  ['no\22']  = 'O-PENDING',
  ['niI']    = 'NORMAL',
  ['niR']    = 'NORMAL',
  ['niV']    = 'NORMAL',
  ['nt']     = 'NORMAL',
  ['v']      = 'VISUAL',
  ['vs']     = 'VISUAL',
  ['V']      = 'V-LINE',
  ['Vs']     = 'V-LINE',
  ['\22']    = 'V-BLOCK',
  ['\22s']   = 'V-BLOCK',
  ['s']      = 'SELECT',
  ['S']      = 'S-LINE',
  ['\19']    = 'S-BLOCK',
  ['i']      = 'INSERT',
  ['ic']     = 'INSERT',
  ['ix']     = 'INSERT',
  ['R']      = 'REPLACE',
  ['Rc']     = 'REPLACE',
  ['Rx']     = 'REPLACE',
  ['Rv']     = 'V-REPLACE',
  ['Rvc']    = 'V-REPLACE',
  ['Rvx']    = 'V-REPLACE',
  ['c']      = 'COMMAND',
  ['cv']     = 'EX',
  ['ce']     = 'EX',
  ['r']      = 'REPLACE',
  ['rm']     = 'MORE',
  ['r?']     = 'CONFIRM',
  ['!']      = 'SHELL',
  ['t']      = 'TERMINAL',
}

local nvim_web_dev_get_icon = require'nvim-web-devicons'.get_icon

local hlutils = require('fruet.utils.hl')

local function set_hls()
    local colors_ft = hlutils.get_highlight_color('Function')
    local colors_tlscp = hlutils.get_highlight_color('TelescopeNormal')
    local colors_tsctx = hlutils.get_highlight_color('TreesitterContext')
    local colors_tblsel = hlutils.get_highlight_color('TabLineSel')

    vim.api.nvim_set_hl(0, 'StatusLineFiletypeSel', { bg = colors_ft.fg, fg = colors_tlscp.bg, bold=true})
    vim.api.nvim_set_hl(0, 'StatusLineFiletypeSymbolSel', { fg = colors_ft.fg, bg = "none" })
    vim.api.nvim_set_hl(0, 'StatusLineFiletype', { bg = colors_tsctx.bg, fg = colors_tlscp.bg, bold=true})
    vim.api.nvim_set_hl(0, 'StatusLineFiletypeSymbol', { fg = colors_tsctx.bg, bg = "none" })
    vim.api.nvim_set_hl(0, 'StatusLineBranch', { bg = colors_tsctx.bg, fg = vim.g.foregroun })
    vim.api.nvim_set_hl(0, 'StatusLineBranchSymbol', { fg = colors_tsctx.bg, bg = "none" })

    vim.api.nvim_set_hl(0, 'StatusLineInfo', { bg = "none", fg = vim.g.foreground })
    vim.api.nvim_set_hl(0, 'StatusLineInfoSymbol', { fg = vim.g.foreground, bg = 'none' })

    vim.api.nvim_set_hl(0, 'StatusLineInfoNC', { bg = "none", fg = vim.g.color8 })
    vim.api.nvim_set_hl(0, 'StatusLineInfoSymbolNC', { fg = vim.g.color8, bg = 'none' })

    --NORMAL DEFINITIONS

    vim.api.nvim_set_hl(0, 'StatusLineModeN', {
        bg = '#458588',  -- Gruvbox Blue
        fg = '#ebdbb2'   -- Gruvbox Light0
    })
    vim.api.nvim_set_hl(0, 'StatusLineModeO', {
        bg = '#d79921',  -- Gruvbox Yellow
        fg = '#282828'   -- Gruvbox Dark0
    })
    vim.api.nvim_set_hl(0, 'StatusLineModeV', {
        bg = '#b16286',  -- Gruvbox Purple
        fg = '#ebdbb2'   -- Gruvbox Light0
    })
    vim.api.nvim_set_hl(0, 'StatusLineModeR', {
        bg = '#cc241d',  -- Gruvbox Red
        fg = '#ebdbb2'   -- Gruvbox Light0
    })
    vim.api.nvim_set_hl(0, 'StatusLineModeI', {
        bg = '#98971a',  -- Gruvbox Green
        fg = '#282828'   -- Gruvbox Dark0
    })
    vim.api.nvim_set_hl(0, 'StatusLineModeS', {
        bg = '#d65d0e',  -- Gruvbox Orange
        fg = '#282828'   -- Gruvbox Dark0
    })
    vim.api.nvim_set_hl(0, 'StatusLineModeM', {
        bg = '#fe8019',  -- Gruvbox Bright Orange
        fg = '#282828'   -- Gruvbox Dark0
    })
    vim.api.nvim_set_hl(0, 'StatusLineModeE', {
        bg = '#fb4934',  -- Gruvbox Bright Red
        fg = '#282828'   -- Gruvbox Dark0
    })
    vim.api.nvim_set_hl(0, 'StatusLineModeC', {
        bg = '#689d6a',  -- Gruvbox Aqua
        fg = '#282828'   -- Gruvbox Dark0
    })
    vim.api.nvim_set_hl(0, 'StatusLineModeT', {
        bg = '#a89984',  -- Gruvbox Gray
        fg = '#282828'   -- Gruvbox Dark0
    })

    --SYMBOLS DEFINITION
    vim.api.nvim_set_hl(0, 'StatusLineModeNSymbol', {
        fg = '#458588',  -- Gruvbox Blue
        bg = "none" -- Gruvbox Light0
    })
    vim.api.nvim_set_hl(0, 'StatusLineModeOSymbol', {
        fg = '#d79921',  -- Gruvbox Yellow
        bg = "none" -- Gruvbox Dark0
    })
    vim.api.nvim_set_hl(0, 'StatusLineModeVSymbol', {
        fg = '#b16286',  -- Gruvbox Purple
        bg = "none" -- Gruvbox Light0
    })
    vim.api.nvim_set_hl(0, 'StatusLineModeRSymbol', {
        fg = '#cc241d',  -- Gruvbox Red
        bg = "none" -- Gruvbox Light0
    })
    vim.api.nvim_set_hl(0, 'StatusLineModeISymbol', {
        fg = '#98971a',  -- Gruvbox Green
        bg = "none" -- Gruvbox Dark0
    })
    vim.api.nvim_set_hl(0, 'StatusLineModeSSymbol', {
        fg = '#d65d0e',  -- Gruvbox Orange
        bg = "none" -- Gruvbox Dark0
    })
    vim.api.nvim_set_hl(0, 'StatusLineModeMSymbol', {
        fg = '#fe8019',  -- Gruvbox Bright Orange
        bg = "none" -- Gruvbox Dark0
    })
    vim.api.nvim_set_hl(0, 'StatusLineModeESymbol', {
        fg = '#fb4934',  -- Gruvbox Bright Red
        bg = "none" -- Gruvbox Dark0
    })
    vim.api.nvim_set_hl(0, 'StatusLineModeCSymbol', {
        fg = '#689d6a',  -- Gruvbox Aqua
        bg = "none" -- Gruvbox Dark0
    })
    vim.api.nvim_set_hl(0, 'StatusLineModeTSymbol', {
        fg = '#a89984',  -- Gruvbox Gray
        bg = "none" -- Gruvbox Dark0
    })

end

function M.get_icon()
    local fname = vim.fn.expand("%:t")
    local extension = vim.fn.expand("%:e")
    local icon, iconhl = nvim_web_dev_get_icon(fname, extension, {default=true})
    if icon == nil then
        return ""
    else
        return icon
    end
end

local function filename_widget(current_window)
    local filename = vim.fn.expand('%:t')

    local symbolhl, normalhl
    if current_window == 1 then
        symbolhl = 'StatusLineFiletypeSymbolSel'
        normalhl = 'StatusLineFiletypeSel'
    else
        symbolhl = 'StatusLineFiletypeSymbol'
        normalhl = 'StatusLineFiletype'
    end
    if filename == '' then
        return ""
    else
        return table.concat{
            '%#'.. symbolhl .. '#',  -- Highlight group
            '',
            '%#' .. normalhl .. '#',  -- Highlight group
            M.get_icon(),
            ' ',
            '%t',  -- File name (tail)
            '%#'.. symbolhl .. '#',  -- Highlight group
            '',
            '%*',  -- Reset highlight
        }
    end
end

function _G._filename_widget(cw)
    return filename_widget(cw)
end

function _G._get_icon()
    return M.get_icon()
end


local function get_diagnostics()
    local diaglist = vim.diagnostic.get(0,{
        severity = {
            vim.diagnostic.severity.ERROR,
            vim.diagnostic.severity.WARN,
            vim.diagnostic.severity.HINT,
            vim.diagnostic.severity.INFO,
        }
    })
    local severity_mapping = {
        [vim.diagnostic.severity.ERROR] = {
            text='[ERR]',
            icon='✘',
            hl='DiagnosticError',
            enabled=true,
            count = 0,
        },
        [vim.diagnostic.severity.WARN] = {
            text='[WARN]',
            icon='▲',
            hl='DiagnosticWarn',
            enabled=true,
            count = 0,
        },
        [vim.diagnostic.severity.INFO] = {
            text='[INFO]',
            hl='DiagnosticInfo',
            icon='ℹ️',
            enabled=true,
            count = 0,
        },
        [vim.diagnostic.severity.HINT] = {
            text='[HINT]',
            hl='DiagnosticHint',
            icon='💡',
            enabled=true,
            count = 0,
        },
    }

    for _, diagnostic in ipairs(diaglist) do
        local severity = diagnostic.severity
        severity_mapping[severity].count = severity_mapping[severity].count + 1
    end

    local output = {}

    local ICONS = false

    for _, render_data in ipairs(severity_mapping) do
        --render_data.count = render_data.count or 0
        if render_data.count > 0 and render_data.enabled then
            table.insert(output, '%#' .. render_data.hl .. '#')
            table.insert(output, render_data.count or 0)
            if ICONS then
                table.insert(output, render_data.icon)
            else
                table.insert(output, render_data.text)
            end
            table.insert(output, '%*')
        end
    end

    return table.concat(output)
end

function _G._get_diagnostics()
   return get_diagnostics()
end

local function branch_name()
	local branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")
    local github_icon = ''
    local branch_icon = ''

	if branch ~= "" then
		return table.concat{
            '%#StatusLineBranch#',
            ' ',
            branch_icon,
            ' ',
            branch,
            '%#StatusLineBranchSymbol#',
            --'',
            --'',
        }
	else
		return ""
	end
end

function _G._branch_name()
    return branch_name()
end

local function get_mode()
    local hl_code = mode_map[vim.api.nvim_get_mode().mode]:sub(1,1)
    --get_diagnostics()
    return table.concat{
        '%#StatusLineMode' .. hl_code:upper() .. '#',
        ' ',
        mode_map[vim.api.nvim_get_mode().mode],
        ' ',
        '%#StatusLineMode' .. hl_code:upper() .. 'Symbol#',
    }
end

function _G._get_mode()
   return get_mode()
end

local function mystatusline()
    local is_cwin = ((vim.g.statusline_winid == vim.fn.win_getid(vim.fn.winnr())) and 1 or 0)
    local infohl = is_cwin == 1 and '%#StatusLineInfo#' or '%#StatusLineInfoNC#'
    return table.concat({
        infohl,
        '%{%v:lua._get_diagnostics()%}',
        '%r',  -- Read-only flag
        '%h',
        '%m',
        '%q',
        '%*',
        '%=',  -- Separator
        '%{%v:lua._filename_widget(' .. is_cwin .. ')%}',
        '%=',  -- Separator
        infohl,
        '[%l/%L]',
        ' ',
        '%p%%',
        ' '
    })
end

function _G._mystatusline()
    return mystatusline()
end

local function setup_statusline()
    vim.opt.laststatus = 2
    vim.opt.statusline = '%!v:lua._mystatusline()'
end


function M.run()
    set_hls()
    setup_statusline()
end

M.enabled = true

return M
