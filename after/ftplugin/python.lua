vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt_local.foldmethod = "expr"

local function select_cell()
    local query = vim.treesitter.query.get("python", "comment_cell")
    if query == nil then
        vim.print("Query not found")
        return
    end

    local bufnr = 0

    local parser = vim.treesitter.get_parser(bufnr, "python")
    local tree = parser:parse()[1]
    local root = tree:root()


    local num_of_rows = vim.api.nvim_buf_line_count(bufnr)
    local start_row, end_row = 0, num_of_rows

    local cursor_row, _ = unpack(vim.api.nvim_win_get_cursor(0))

    for id, node in query:iter_captures(root, bufnr, 0, -1) do
        local row, _, _, _ = node:range()
        if row < cursor_row then
            start_row = row + 1
        elseif row > cursor_row and end_row == vim.api.nvim_buf_line_count(bufnr) then
            end_row = row - 1
            break
        end
    end

    vim.api.nvim_win_set_cursor(0, {start_row + 1, 0})
    vim.cmd("normal! V")
    if num_of_rows <= end_row then
        end_row = end_row - 1
    end
    vim.api.nvim_win_set_cursor(0, {end_row + 1, 0})
end

_G.select_python_cell = select_cell

local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set('n', 'vc', function ()
    select_cell()
end, {buffer=bufnr})

vim.keymap.set('n', 'sc', function()
    select_cell()
    vim.cmd('normal! "0y')
    local text = vim.fn.getreg('0')
    vim.fn["slime#send"](text)
end
    , {buffer=bufnr})

vim.keymap.set('n', 'ss', function()
    vim.cmd('normal! vip')
    vim.cmd('normal! "0y')
    local text = vim.fn.getreg('0')
    vim.print(text)
    vim.fn["slime#send"](text)
end
    , {buffer=bufnr})
