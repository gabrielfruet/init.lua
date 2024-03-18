return require('packer').startup(function(use) use("wbthomason/packer.nvim")

    use("nvim-lua/plenary.nvim")
    use("nvim-lua/popup.nvim")
    use("nvim-telescope/telescope.nvim")
    use("nvim-telescope/telescope-ui-select.nvim")

    use("nvim-treesitter/nvim-treesitter", {
        run = ":TSUpdate"
    })

    use('kyazdani42/nvim-web-devicons')-- optional, for file icons
    use('kyazdani42/nvim-tree.lua')
    -- Unless you are still migrating, remove the deprecated commands from v1.x

    use("nvim-treesitter/playground")
    use("romgrk/nvim-treesitter-context")

    use "folke/tokyonight.nvim"
    use "themercorp/themer.lua"

    use {'nvim-lualine/lualine.nvim'}

    use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}

    use("sbdchd/neoformat")
    use("TimUntersberger/neogit")
    use("windwp/nvim-autopairs")
    use({
        "aserowy/tmux.nvim",
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
    })
    use("xiyaowong/nvim-transparent")

    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-buffer", "hrsh7th/cmp-nvim-lsp",
            'quangnguyen30192/cmp-nvim-ultisnips', 'hrsh7th/cmp-nvim-lua',
            'octaltree/cmp-look', 'hrsh7th/cmp-path', 'hrsh7th/cmp-calc',
            'f3fora/cmp-spell', 'hrsh7th/cmp-emoji'
        }
    }
    use 'L3MON4D3/LuaSnip'
    use 'rafamadriz/friendly-snippets'

    use 'onsails/lspkind-nvim'

    use {"williamboman/mason.nvim"}
    use "williamboman/mason-lspconfig.nvim"
    use 'neovim/nvim-lspconfig'

    use 'folke/neodev.nvim'
end)
