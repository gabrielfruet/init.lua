return {
    "nvim-lua/plenary.nvim",
    "nvim-lua/popup.nvim",
    "nvim-treesitter/playground",
    "romgrk/nvim-treesitter-context",
    "folke/tokyonight.nvim",
    "themercorp/themer.lua",
    'nvim-lualine/lualine.nvim',
    "sbdchd/neoformat",
    "TimUntersberger/neogit",
    "windwp/nvim-autopairs",
    {"aserowy/tmux.nvim",
        config = function()
            require("tmux").setup({
                -- overwrite default configuration
                -- here, e.g. to enable default bindings
                copy_sync = {
                    -- enables copy sync and overwrites all register actions to
                    -- sync registers *, +, unnamed, and 0 till 9 from tmux in advance
                    enable = true,
                },
                navigation = {
                    -- enables default keybindings (C-hjkl) for normal mode
                    enable_default_keybindings = true,
                },
                resize = {
                    -- enables default keybindings (A-hjkl) for normal mode
                    enable_default_keybindings = true,
                }
            })
        end
    },
    "xiyaowong/nvim-transparent",
    {"hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-buffer", "hrsh7th/cmp-nvim-lsp",
            'quangnguyen30192/cmp-nvim-ultisnips', 'hrsh7th/cmp-nvim-lua',
            'octaltree/cmp-look', 'hrsh7th/cmp-path', 'hrsh7th/cmp-calc',
            'f3fora/cmp-spell', 'hrsh7th/cmp-emoji'
        }
    },
    'L3MON4D3/LuaSnip',
    'rafamadriz/friendly-snippets',
    'onsails/lspkind-nvim',
    {"williamboman/mason.nvim"},
    "williamboman/mason-lspconfig.nvim",
    'neovim/nvim-lspconfig',
    'folke/neodev.nvim',
}
