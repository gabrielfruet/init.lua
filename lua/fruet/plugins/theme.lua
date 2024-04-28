return {
    {
        "nyoom-engineering/oxocarbon.nvim",
        config = function ()
            vim.opt.background = "dark" -- set this to dark or light
            vim.cmd.colorscheme "oxocarbon"
        end
    },
    {
        "bluz71/vim-moonfly-colors",
        name = "moonfly",
        enabled = false,
        lazy = false,
        priority = 1000,
        config=function ()
            vim.cmd [[colorscheme moonfly]]
        end
    },
    {
        "folke/tokyonight.nvim",
        priority=1000,
        enabled=false,
        config=function ()
            require('tokyonight').setup{
                -- your configuration comes here
                -- or leave it empty to use the default settings
                style = "moon", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
                light_style = "day", -- The theme is used when the background is set to light
                transparent = false, -- Enable this to disable setting the background color
                transparent_sidebar = false, -- Enable this to disable setting the background color
                terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
                styles = {
                    -- Style to be applied to different syntax groups
                    -- Value is any valid attr-list value for `:help nvim_set_hl`
                    comments = {},
                    keywords = { italic = true },
                    functions = { bold = true },
                    variables = {},
                    -- Background styles. Can be "dark", "transparent" or "normal"
                    sidebars = "dark", -- style for sidebars, see below
                    floats = "normal", -- style for floating windows
                },
                sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
                day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
                hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
                dim_inactive = false, -- dims inactive windows
                lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold

                --- You can override specific color groups to use other groups or a hex color
                --- function will be called with a ColorScheme table
                ---@param colors ColorScheme
                on_colors = function(colors) end,

                --- You can override specific highlights to use other groups or a hex color
                --- function will be called with a Highlights and ColorScheme table
                ---@param highlights Highlights
                ---@param colors ColorScheme
                on_highlights = function(hl, c)
                    hl.IncSearch = {
                        bg=c.orange,
                        fg=c.bg,
                    }
                    hl.FloatBorder = {
                        bg = c.bg,
                        fg = c.white,
                    }
                    hl.Pmenu = {
                        bg = c.bg,
                        fg = c.fg,
                    }
                    local prompt = "#2d3149"
                    hl.TelescopeNormal = {
                        bg = c.bg_dark,
                        fg = c.fg_dark,
                    }
                    hl.TelescopeBorder = {
                        bg = c.bg_dark,
                        fg = c.bg_dark,
                    }
                    hl.TelescopePromptNormal = {
                        bg = prompt,
                    }
                    hl.TelescopePromptBorder = {
                        bg = prompt,
                        fg = prompt,
                    }
                    hl.TelescopePromptTitle = {
                        bg = prompt,
                        fg = prompt,
                    }
                    hl.TelescopePreviewTitle = {
                        bg = c.bg_dark,
                        fg = c.bg_dark,
                    }
                    hl.TelescopeResultsTitle = {
                        bg = c.bg_dark,
                        fg = c.bg_dark,
                    }
                    hl.AutorunNone = {
                        bg = c.bg_dark,
                        fg = c.fg_dark,
                    }
                    hl.AutorunRounded = {
                        bg = c.bg,
                        fg = c.fg,
                    }
                    hl.AutorunSolid = {
                        bg = c.bg,
                        fg = c.fg,
                    }
                end,
            }

            vim.cmd'colorscheme tokyonight'
        end,
    }
}