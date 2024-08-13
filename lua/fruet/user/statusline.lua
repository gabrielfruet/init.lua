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

local icons_by_extension = require'nvim-web-devicons'.get_icons_by_extension()

local function get_highlight_color(group_name)
    local hl_details = vim.api.nvim_get_hl(0, { name = group_name, link=false })

    local function rgb_to_hex(rgb)
        if not rgb or rgb == "none" then return "none" end
        return string.format("#%06x", rgb)
    end

    return {
        fg = rgb_to_hex(hl_details.fg),
        bg = rgb_to_hex(hl_details.bg),
        sp = rgb_to_hex(hl_details.sp)
    }
end

local function set_hls()
    local colors_ft = get_highlight_color('Function')
    local colors_tlscp = get_highlight_color('TelescopeNormal')
    local colors_tsctx = get_highlight_color('TreesitterContext')
    vim.api.nvim_set_hl(0, 'StatusLineFiletype', { bg = colors_ft.fg, fg = colors_tlscp.bg, bold=true})
    vim.api.nvim_set_hl(0, 'StatusLineFiletypeSymbol', { fg = colors_ft.fg, bg = "none" })
    vim.api.nvim_set_hl(0, 'StatusLineBranch', { bg = colors_tsctx.bg, fg = '#ffffff' })
    vim.api.nvim_set_hl(0, 'StatusLineBranchSymbol', { fg = colors_tsctx.bg, bg = "none" })


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

end



local function get_icon()
    local extension = vim.fn.expand("%:e")
    local icon_details = icons_by_extension[extension]
    if icon_details == nil then
        return ""
    else
        return icon_details.icon
    end
end

local function filename_widget()
    local filename = vim.fn.expand('%:t')
    if filename == '' then
        return ""
    else
        return table.concat{
            '%#StatusLineFiletypeSymbol#',  -- Highlight group
            '',
            '%#StatusLineFiletype#',  -- Highlight group
            get_icon(),
            ' ',
            '%t',  -- File name (tail)
            '%#StatusLineFiletypeSymbol#',  -- Highlight group
            '',
            '%*',  -- Reset highlight
        }
    end
end

function _G._filename_widget()
    return filename_widget()
end

function _G._get_icon()
    return get_icon()
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
            '',
            '%*'
        }
	else
		return ""
	end
end

function _G._branch_name()
    return branch_name()
end

local function get_diagnostics()
    local diagnostic_count = vim.diagnostic.count(0,{})
    local severity_mapping = {
        [vim.diagnostic.severity.ERROR] = {
            text='[ERR]',
            icon='X',
            hl='DiagnosticError',
            enabled=true,
        },
        [vim.diagnostic.severity.WARN] = {
            text='[WARN]',
            icon='⚠',
            hl='DiagnosticWarn',
            enabled=true,
        },
        [vim.diagnostic.severity.INFO] = {
            text='[INFO]',
            hl='DiagnosticInfo',
            enabled=true,
        },
        [vim.diagnostic.severity.HINT] = {
            text='[HINT]',
            hl='DiagnosticHint',
            enabled=false,
        },
    }

    for severity, count in pairs(diagnostic_count) do
        severity_mapping[severity].count = count
    end

    local output = {}

    for _, render_data in ipairs(severity_mapping) do
        render_data.count = render_data.count or 0
        if render_data.count > 0 and render_data.enabled then
            table.insert(output, '%#' .. render_data.hl .. '#')
            table.insert(output, render_data.count or 0)
            table.insert(output, render_data.text)
            table.insert(output, '%*')
        end
    end

    return table.concat(output)
end

function _G._get_diagnostics()
   return get_diagnostics()
end

local function get_mode()
    local hl_code = mode_map[vim.api.nvim_get_mode().mode]:sub(1,1)
    get_diagnostics()
    return table.concat{
        '%#StatusLineMode' .. hl_code:upper() .. '#',
        ' ',
        mode_map[vim.api.nvim_get_mode().mode],
        ' ',
        '%*'
    }
end

function _G._get_mode()
   return get_mode()
end



local function setup_statusline()
    vim.opt.laststatus = 2
    vim.opt.statusline = table.concat({
        '%r',  -- Read-only flag
        '%{%v:lua._get_mode()%}',
        --'%{%v:lua._get_icon()%}',
        '%{%v:lua._branch_name()%}',
        '%=',  -- Separator
        '%{%v:lua._filename_widget()%}',
        '%=',  -- Separator
        '%{%v:lua._get_diagnostics()%}',
        --'%-14.(%l,%c%V%)',
        ' ',
        '%P'
    })
end

function M.run()
    set_hls()
    setup_statusline()
end

M.enabled = true

return M
