local fg = '#202020'

return {
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
        options = {
            --separator_style = "slant",

            offsets = {
                {
                    filetype = "NvimTree",
                    text = "File Explorer",
                    text_align ="center",
                    separator = true,
                    highlights = "NvimTreeNormal"
                }
            }
        },
        highlights = {
            separator = {
                fg = fg,
            },
            separator_visible = {
                fg = fg,
            },
            separator_selected = {
                fg = fg,
            },
        },
    }
}


