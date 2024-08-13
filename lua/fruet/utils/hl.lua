local M = {}

function M.get_highlight_color(group_name)
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

return M
