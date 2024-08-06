vim.cmd('source ~/.cache/wal/colors-wal.vim')

local function get_highlight_color(group_name)
    -- Fetch highlight details
    local hl_details = vim.api.nvim_get_hl(0, {name=group_name})

    -- Extract and convert color values from RGB to HEX
    local function rgb_to_hex(rgb)
        if not rgb or rgb == "none" then return "none" end
        return string.format("#%06x", rgb)
    end

    -- Prepare the color information
    local colors = {
        fg = rgb_to_hex(hl_details.fg),
        bg = rgb_to_hex(hl_details.bg),
        sp = rgb_to_hex(hl_details.sp)
    }

    return colors
end

local function set_highlight(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

local function configure_highlights()
    local c = {
        prompt = get_highlight_color("Visual").bg,
        bg = vim.g.background,
        fg = vim.g.foreground,
        bg_dark = vim.g.color1,
        fg_dark = vim.g.color1,
        bg_light = vim.g.color8,
        fg_light = vim.g.color8,
        selected = get_highlight_color("BlueItalic").fg,
        white = '#ffffff',
    }

    -- Apply highlight configurations
    set_highlight('FloatBorder', {bg = "none", fg=c.fg})
    set_highlight('NormalFloat', {bg = "none", fg=c.fg})
    set_highlight('TreesitterContext', {bg = c.bg_light, fg=c.fg_light})

    set_highlight('CmpItemMenu', {bg = c.bg, fg = c.fg})
    set_highlight('BufferLineFill', {bg = c.bg, fg = c.fg})
    set_highlight('Pmenu', {bg = c.bg, fg = c.fg})

    local da = get_highlight_color('DiffAdd')
    set_highlight('TelescopeSelection', {bg = da.bg, fg = c.selected})
    set_highlight('CmpItemAbbrMatch', {bg = da.bg, fg = c.selected})


    set_highlight('InfoText', {bg = c.bg, fg=c.fg})
    set_highlight('TelescopeNormal', {bg = c.bg, fg = c.fg})
    set_highlight('TelescopePromptBorder', {bg = c.bg, fg = c.bg})
    set_highlight('TelescopeResultsBorder', {bg = c.bg, fg = c.bg})
    set_highlight('TelescopePreviewBorder', {bg = c.bg, fg = c.bg})
    --set_highlight('TelescopePromptNormal', {bg = c.bg_light, fg = c.fg_light})
    --set_highlight('TelescopePromptCounter', {bg = c.bg_light, fg = c.fg_light})
    --set_highlight('TelescopePromptTitle', {bg = c.bg_light, fg = c.fg_light})

    --set_highlight('TelescopePreviewTitle', {bg = c.bg_dark, fg = c.bg_dark})
    --set_highlight('TelescopeResultsTitle', {bg = c.bg_dark, fg = c.bg_dark})

    set_highlight('AutorunNone', {bg = c.bg_dark, fg = c.fg_dark})
    set_highlight('AutorunRounded', {bg = c.bg, fg = c.fg})
    set_highlight('AutorunSolid', {bg = c.bg, fg = c.fg})
end

-- Example usage: Define a color scheme and apply it

local tokyonight = {
    "folke/tokyonight.nvim",
    priority=1000,
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

local moonfly = {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    lazy = false,
    priority = 1000,
    config=function ()
        vim.cmd [[colorscheme moonfly]]
    end
}

local oxocarbon = {
    "nyoom-engineering/oxocarbon.nvim",
    priority=1000,
    config = function ()
        vim.cmd.colorscheme "oxocarbon"
    end
}

local onehalf = {
    'sonph/onehalf',
    rtp = 'vim',
    priority = 1000,
    config = function ()
        vim.cmd[[colorscheme onehalf]]
    end
}

local spacecamp = {
    'jaredgorski/spacecamp',
    priority = 1000,
    config = function()
        vim.cmd[[colorscheme spacecamp]]
    end

}

local purify = {
    'kyoz/purify',
    rtp = 'vim',
    priority = 1000,
    config = function ()
        vim.cmd[[colorscheme purify]]
    end
}

local sonokai = {
    'sainnhe/sonokai',
    priority=1000,
    config = function ()
        vim.g.sonokai_style = 'default'
        vim.g.sonokai_transparent_background=2
        vim.cmd[[colorscheme sonokai]]
    end
}

local monokai = {
    'ku1ik/vim-monokai',
    priority=1000,
    config=function()
        vim.cmd[[syntax enable]]
        vim.cmd[[colorscheme monokai]]
    end
}

local cyberdream = {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function ()
        require("cyberdream").setup({
            -- Enable transparent background
            transparent = false,

            -- Enable italics comments
            italic_comments = false,

            -- Replace all fillchars with ' ' for the ultimate clean look
            hide_fillchars = false,

            -- Modern borderless telescope theme
            borderless_telescope = true,

            -- Set terminal colors used in `:terminal`
            terminal_colors = true,

            theme = {
                variant = "default", -- use "light" for the light variant
                highlights = {
                    -- Highlight groups to override, adding new groups is also possible
                    -- See `:h highlight-groups` for a list of highlight groups or run `:hi` to see all groups and their current values

                    -- Example:
                    Comment = { fg = "#696969", bg = "NONE", italic = true },

                    -- Complete list can be found in `lua/cyberdream/theme.lua`
                },

                -- Override a color entirely
                colors = {
                    -- For a list of colors see `lua/cyberdream/colours.lua`
                    -- Example:
                    bg = "#000000",
                    green = "#00ff00",
                    magenta = "#ff00ff",
                },
            },
        })
        vim.cmd("colorscheme cyberdream")
    end
}

local tender =  {
    'jacoborus/tender.vim',
    lazy=false,
    priority=1000,
    config = function ()
        vim.cmd("colorscheme tender")
    end
}

local gruvbox = {
    "ellisonleao/gruvbox.nvim",
    lazy=false,
    priority = 1000 ,
    config = function ()
       vim.cmd("colorscheme gruvbox")
    end,
}

-- Function to get the highlight group of the text under the cursor
local function print_highlight_groups_under_cursor()
    local line = vim.fn.line('.')      -- Current line number
    local col = vim.fn.col('.')        -- Current column number

    -- Get the buffer number and syntax ID at the position
    local bufnr = vim.api.nvim_get_current_buf()
    local synID = vim.fn.synID(line, col, true)
    local synIDtrans = vim.fn.synIDtrans(synID)
    local hlGroup = vim.fn.synIDattr(synIDtrans, 'name')

    -- Print the highlight group
    print('Highlight group under cursor:', hlGroup)
end


vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        -- Optional: Bind the function to a key for easy access
        vim.keymap.set('n', '<leader>hg', print_highlight_groups_under_cursor, { noremap = true})
        set_highlight("Normal", {bg=vim.g.background, fg=vim.g.foreground})
        configure_highlights()
    end
})

return gruvbox
