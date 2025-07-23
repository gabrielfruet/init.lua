return {
    'stevearc/conform.nvim',
    opts = {
        formatters_by_ft = {
            python = { "ruff_fix", "ruff_format" },
        },
        format_on_save = {
            lsp_fallback = false,
            timeout_ms = 1000,
        },
    },
}
