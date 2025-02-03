local conform = require('conform')
conform.setup({})
conform.formatters_by_ft["python"] = {"ruff_format"}

local lint = require('lint')
lint.linters_by_ft["python"] = {"ruff"}

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    conform.format({ bufnr = args.buf })
    lint.try_lint()
  end,
})
