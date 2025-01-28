local function run()
    local map = vim.keymap.set
    local noremap = { noremap = true}
    local silent = { silent = true, noremap = true }

    --save buffer
    map('n', '<c-s>', '<cmd>w!<cr>', noremap) -- S ave
    map('n', '<c-q>', '<cmd>qa<cr>', noremap) -- Q uit
    map('n', '<c-e>', '<cmd>qa!<cr>', noremap) -- E xit

    --remove highlights
    map('n', ',', '<cmd>noh<cr>', noremap)

    --escape key
    map('i', 'jk', '<esc>', noremap)

    --window mov
    -- map('n', '<c-h>', '<c-w>h', noremap)
    -- map('n', '<c-j>', '<c-w>j', noremap)
    -- map('n', '<c-k>', '<c-w>k', noremap)
    -- map('n', '<c-l>', '<c-w>l', noremap)

    --buffer
    map('n', '<leader>bc', '<cmd>enew | bdelete #<cr>', noremap)
    map('n', '<leader>bn', '<cmd>bn<cr>', noremap)

    --for the gmk67 knob
    map('n', '<f12>', '<cmd>bnext<cr>', noremap)
    map('n', '<f11>', '<cmd>bprevious<cr>', noremap)

    map('n', '<Right>', '<cmd>bnext<cr>', noremap)
    map('n', '<Left>', '<cmd>bprevious<cr>', noremap)
    map('n', '<Down>', '<cmd>bd<cr>', noremap)
    map('n', '<Up>', '<cmd>bn<cr>', noremap)


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
            title = " 󰈙 Documentation "
        }
    )
    map('n', 'K', vim.lsp.buf.hover, noremap)
    map('n', 'gd', vim.lsp.buf.definition, noremap)
    map('n', 'gD', vim.lsp.buf.declaration, noremap)
    map('n', 'gi', vim.lsp.buf.implementation, noremap)
    map('n', '<leader>ca', vim.lsp.buf.code_action, noremap)
    map('n', '<leader>vrr', vim.lsp.buf.references, noremap)
    map('n', '<leader>vrn',vim.lsp.buf.rename, noremap)
    map('n', '<leader>rf', vim.lsp.buf.references, noremap)
    --map('n', '<leader>ws', vim.lsp.buf.workspace_symbol)

    --diagnostic
    map('n', '<leader>dv', vim.diagnostic.open_float, noremap)
    map('n', '<leader>dq', vim.diagnostic.setloclist, noremap)

    --swapnig lines
    map('n', '<S-Down>', "<cmd>move +1<cr>", silent)
    map('n', '<S-Up>', "<cmd>move -2<cr>", silent)

    --splits
    map('n', '<leader>sv', '<cmd>vs<cr>')
    map('n', '<leader>sh', '<cmd>sp<cr>')
    map('n', '<leader>sc', '<cmd>close<cr>')

    --quickfix
    map('n', '<leader>co', '<cmd>copen<cr>')
    map('n', '[c', '<cmd>cnext<cr>')
    map('n', ']c', '<cmd>cprevious<cr>')
    map('n', '<leader>cc', '<cmd>cclose<cr>')
    map('n', '<leader>cj', '<cmd>cnewer<cr>')
    map('n', '<leader>ck', '<cmd>colder<cr>')

    --locationlist
    map('n', '<leader>lo', '<cmd>lopen<cr>')
    map('n', '[w', '<cmd>lnext<cr>')
    map('n', ']w', '<cmd>lprevious<cr>')
    map('n', '<leader>lc', '<cmd>lclose<cr>')
    map('n', '<leader>lj', '<cmd>lnewer<cr>')
    map('n', '<leader>lk', '<cmd>lolder<cr>')

    --correct o<esc>i behavior, identing correctly
    vim.cmd[[function! IndentWithI()
        if len(getline('.')) == 0
            return "\"_cc"
        else
            return "i"
        endif
    endfunction
    nnoremap <expr> i IndentWithI()]]
end

return {
    enabled = true,
    run = run,
}
