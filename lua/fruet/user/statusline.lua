local M = {}

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
    vim.api.nvim_set_hl(0, 'StatusLineFiletype', { bg = colors_ft.fg, fg = colors_tlscp.bg })
    vim.api.nvim_set_hl(0, 'StatusLineFiletypeSymbol', { fg = colors_ft.fg, bg = "none" })
    vim.api.nvim_set_hl(0, 'StatusLineBranch', { bg = colors_tsctx.bg, fg = '#ffffff' })
    vim.api.nvim_set_hl(0, 'StatusLineBranchSymbol', { fg = colors_tsctx.bg, bg = "none" })

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

local function get_icon()
    local extension = vim.fn.expand("%:e")
    local icon_details = icons_by_extension[extension]
    if icon_details == nil then
        return ""
    else
        return icon_details.icon
    end
end

function _G._get_icon()
    return get_icon()
end

local function branch_name()
	local branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")
    local github_icon = ''

	if branch ~= "" then
		return table.concat{
            '%#StatusLineBranch#',
            ' ',
            github_icon,
            '  ',
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



local function setup_statusline()
    vim.opt.statusline = table.concat({
        '%r',  -- Read-only flag
        --'%{%v:lua._get_icon()%}',
        '%{%v:lua._branch_name()%}',
        '%=',  -- Separator
        '%{%v:lua._filename_widget()%}',
        '%=',  -- Separator
        '%-14.(%l,%c%V%)',
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
