local M = {}

M.CREATE_BUFFER = function () return vim.api.nvim_create_buf(false, true) end
M.output_buffer = M.CREATE_BUFFER


M.get_output_buffer = function ()
    local bufnr = M.output_buffer()

    if vim.api.nvim_buf_is_valid(bufnr) then
        return bufnr
    end

    M.output_buffer = M.CREATE_BUFFER

    return M.output_buffer()
end

M.set_ouptut_buffer = function (bufnr)
    M.output_buffer = function () return bufnr end
end

return M
