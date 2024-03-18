
return {
    'nvim-lualine/lualine.nvim',
    config = function ()
        local custom_tokyonight = require'lualine.themes.tokyonight'
        custom_tokyonight.normal.a.bg = 'ff7c7c'
        require'lualine'.setup{
            options = {
                theme = custom_tokyonight,
                component_separators = '|',
                section_separators = { left = '', right = '' },
                disabled_filetypes = { 'packer', 'NvimTree', 'neo-tree'}
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
