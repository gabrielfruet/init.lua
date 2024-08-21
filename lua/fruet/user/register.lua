local M = {}

M.registers = {
    '"', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '-', ':', '.', '/',
    '*', '+', '=', '_', '~', '#', '%', '\"', '^', '@', '!', '>', '<', '{', '}',
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p',
    'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
}


M.run  = function ()

    local register_by_byte = {}
    for _, reg in pairs(M.registers) do
        register_by_byte[string.byte(reg)] = true
    end

    local function get_register()
        local char = vim.fn.getcharstr()
        if not register_by_byte[string.byte(char)] then
            return nil
        end
        return char
    end

    local function edit_register()

        local reg = get_register()
        if not reg then
            return
        end
        local regcontent = vim.fn.getreg(reg)

        vim.ui.input({
            prompt = string.format('Edit the register \'%s\'', reg),
            default = regcontent,
        }, function (input)
            if not input then return end
            local ok, _ = pcall(vim.fn.setreg, reg, input)
            if not ok then
                vim.print(string.format('No register named \'%s\'', reg))
            end
        end)

    end

    vim.keymap.set('n', '<leader>em', edit_register, {noremap=true})
end

return M
