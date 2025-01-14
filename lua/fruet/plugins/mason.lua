return {
    {
        "williamboman/mason.nvim",
        priority=100,
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        }
    },
    {

        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            'neovim/nvim-lspconfig',
        },
        opts={
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "clangd",
                "cmake",
                "bashls",
                "texlab",
                "clangd",
                "gopls",
                "bashls",
                "basedpyright",
                "dockerls",
            },

        }
    },
    {
        "rshkarin/mason-nvim-lint",
        event={
            "BufReadPre",
            "BufNewFile"
        },
        dependencies={
            "williamboman/mason.nvim",
            "mfussenegger/nvim-lint",
        },
        opts = {
            -- A list of linters to automatically install if they're not already installed. Example: { "eslint_d", "revive" }
            -- This setting has no relation with the `automatic_installation` setting.
            -- Names of linters should be taken from the mason's registry.
            ---@type string[]
            ensure_installed = {
                'shellcheck',
                'pylint',
                'checkmake',
                'luacheck',
            },

            -- Whether linters that are set up (via nvim-lint) should be automatically installed if they're not already installed.
            -- It tries to find the specified linters in the mason's registry to proceed with installation.
            -- This setting has no relation with the `ensure_installed` setting.
            ---@type boolean
            automatic_installation = true,

            -- Disables warning notifications about misconfigurations such as invalid linter entries and incorrect plugin load order.
            quiet_mode = false,
        }
    }
}
