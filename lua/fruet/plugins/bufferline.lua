local fg = '#202020'

return {
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    enabled=false,
    opts = {
        options = {
            --'slant' conflicts with transparency.
            separator_style = "thin",
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "File Explorer",
                    text_align ="center",
                    separator = true,
                    highlights = "NvimTreeNormal"
                },
                {
                    filetype = "neo-tree",
                    text = "File Explorer",
                    text_align ="center",
                    separator = true,
                    highlights = {"NeoTreeNormal", "NeoTreeNormalNC"}
                }
            }
        },
        --[[
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
        --]]
    }
}


