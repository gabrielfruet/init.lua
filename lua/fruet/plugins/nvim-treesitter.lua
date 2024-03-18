return {
    "nvim-treesitter/nvim-treesitter",
    build=":TSUpdate",
    opts={
        -- A list of parser names, or "all"
        ensure_installed = "all",

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        auto_install = true,

        -- List of parsers to ignore installing (for "all")
        filetypes = {
            "html",
            "javascript",
            "javascriptreact",
            "svelte",
            "typescript",
            "typescriptreact",
            "vue",
            "xml",
        },
        ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
        -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

        highlight = {
            -- `false` will disable the whole extension
            enable = true,

            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = true,
        },
        indent = {enable = true, disable = {"yaml"}},
    }
}
