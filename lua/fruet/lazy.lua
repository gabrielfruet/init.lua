local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {

    "nvim-lua/plenary.nvim",
    "nvim-lua/popup.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    {"nvim-treesitter/nvim-treesitter",
        build=":TSUpdate"
    },
    'kyazdani42/nvim-web-devicons',
    'kyazdani42/nvim-tree.lua',
    "nvim-treesitter/playground",
    "romgrk/nvim-treesitter-context",
    "folke/tokyonight.nvim",
    "themercorp/themer.lua",
    'nvim-lualine/lualine.nvim',
    {'akinsho/bufferline.nvim', dependencies = 'kyazdani42/nvim-web-devicons'},
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

local opts = {}

require("lazy").setup(plugins,opts)


