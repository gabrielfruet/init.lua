local function run()
    local map = vim.keymap.set
    local noremap = { noremap = true}
    local silent = { silent = true, noremap = true }

    --save buffer
    map('n', '<c-s>', '<cmd>w!<cr>', noremap) -- S ave
    map('n', '<c-q>', '<cmd>qa<cr>', noremap) -- Q uit
    map('n', '<c-e>', '<cmd>qa!<cr>', noremap) -- E xit

    --escape key
    map('i', 'jk', '<esc>', noremap)

    --window mov
    map('n', '<c-h>', '<c-w>h', noremap)
    map('n', '<c-j>', '<c-w>j', noremap)
    map('n', '<c-k>', '<c-w>k', noremap)
    map('n', '<c-l>', '<c-w>l', noremap)

    --buffer
    map('n', '<f4>', '<cmd>bd<cr>', noremap)
    map('n', '<f2>', '<cmd>bnext<cr>', noremap)
    map('n', '<f1>', '<cmd>bprevious<cr>', noremap)

    --wrap
    map('v', [[<leader>"]], [[di""<Esc>P]], noremap)
    map('v', [[<leader>']], [[di''<Esc>P]], noremap)
    map('v', [[<leader>`]], [[di``<Esc>P]], noremap)
    map('v', [[<leader>(]], [[di()<Esc>P]], noremap)
    map('v', [[<leader>[]], [[di[]<Esc>P]], noremap)

    --copy/paste
    map('v', '<leader>y', [["+y]], silent)
    map('n', '<leader>p', [["+p]], silent)
    map('n', '<leader>ya', [[ggVG"+y]], silent)

    --lsp
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, {
            border = "rounded",
            title = "doc"
        }
    )
    map('n', 'K', vim.lsp.buf.hover, noremap)
    map('n', 'gd', vim.lsp.buf.definition, noremap)
    map('n', 'gi', vim.lsp.buf.implementation, noremap)
    map('n', '<leader>ca', vim.lsp.buf.code_action, noremap)
    map('n', '<leader>vrr', vim.lsp.buf.references, noremap)
    map('n', '<leader>vrn',vim.lsp.buf.rename, noremap)
    map('n', '<leader>rf', vim.lsp.buf.references, noremap)
    --map('n', '<leader>ws', vim.lsp.buf.workspace_symbol)

    --diagnostic
    map('n', '<leader>vd', vim.diagnostic.open_float, noremap)

    --swapnig lines
    map('n', '<S-Down>', "<cmd>move +1<cr>", silent)
    map('n', '<S-Up>', "<cmd>move -2<cr>", silent)
end

return {
    enabled = true,
    run = run,
}
