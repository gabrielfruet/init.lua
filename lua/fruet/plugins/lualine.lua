return {
    'nvim-lualine/lualine.nvim',
    config = function ()
        local nvim_tree_shift = {
            function()
                local len = vim.api.nvim_win_get_width(require('nvim-tree.view').get_winnr()) 
                local title = "NvimTree"
                local left = (len - #title) / 2
                local right = len  - left - #title
                return string.rep(' ', left) .. title .. string.rep(' ', right)
            end,
            cond = require('nvim-tree.view').is_visible,
            color = 'Normal'
        }
        local custom_tokyonight = require'lualine.themes.tokyonight'
        custom_tokyonight.normal.a.bg = 'ff7c7c'

        local colors = {
            blue   = '#80a0ff',
            cyan   = '#79dac8',
            black  = '#080808',
            white  = '#c6c6c6',
            red    = '#ff5c5c',
            violet = '#d183e8',
            grey   = '#202030',
        }

        local bubbles_theme = {
            normal = {
                a = { fg = colors.black, bg = colors.red },
                b = { fg = colors.black, bg = colors.grey },
                c = { fg = colors.black, bg = colors.violet },
            },

            insert = { a = { fg = colors.black, bg = colors.blue } },
            visual = { a = { fg = colors.black, bg = colors.cyan } },
            replace = { a = { fg = colors.black, bg = colors.red } },

            inactive = {
                a = { fg = colors.white, bg = colors.black },
                b = { fg = colors.white, bg = colors.black },
                c = { fg = colors.black, bg = colors.black },
            },
        }

        require('lualine').setup {
            options = {
                theme = custom_tokyonight,
                component_separators = '|',
                section_separators = { left = '', right = '' },
                disabled_filetypes = { 'packer', 'NvimTree' }
            },
            sections = {
                lualine_a = {
                    { 'mode', separator = { left = '' }, right_padding = 2 },
                },
                lualine_b = { 'filename', 'branch' },
                lualine_c = { 'fileformat' },
                lualine_x = {},
                lualine_y = { 'filetype', 'progress'},
                lualine_z = {
                    { 'location', separator = { right = '' }, left_padding = 2 },
                },
            },
            inactive_sections = {
                lualine_a = { 'filename' },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = { 'location' },
            },
            tabline = {},
            extensions = {},
        }
    end
}
