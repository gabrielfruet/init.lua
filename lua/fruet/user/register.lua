local M = {}

M.run  = function ()

    local function get_register()
        local char = vim.fn.getcharstr()
        if string.byte(char) == 27 then
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
            vim.fn.setreg(reg, input)
        end)

    end

    vim.keymap.set('n', '<leader>em', edit_register, {noremap=true})
end

return M
