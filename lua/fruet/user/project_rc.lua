local function source_rc(path)
    vim.cmd("source " .. path)
end

local function create_ask_screen()
    local buf = vim.api.nvim_create_buf(false, true)
    local width = 30
    local height = 3
    local opts = {
        style = "minimal",
        relative = "editor",
        width = width,
        height = height,
        row = (vim.o.lines - height) / 2,
        col = (vim.o.columns - width) / 2,
        border = "rounded",
    }

    local normalhl = vim.api.nvim_get_hl(0, {name='Normal', link=false})
    local fnhl = vim.api.nvim_get_hl(0, {name='Function', link=false})

    vim.api.nvim_set_hl(0, "AskScreenBorder", { fg = string.format("#%06x",normalhl.fg), bg = "none" })
    vim.api.nvim_set_hl(0, "AskScreenText", { fg = string.format("#%06x",fnhl.fg), bg = "none", bold = true })
    vim.api.nvim_set_hl(0, "AskScreenBg", { bg = "none" })

    -- Apply buffer options
    vim.bo[buf]['buftype'] = 'nofile'
    vim.bo[buf]['bufhidden'] = 'wipe'

    -- Centering the text
    local question = "Source rc.lua? (y / q)"
    local padding = math.floor((width - #question) / 2)
    local centered_text = string.rep(" ", padding) .. question

    -- Set the centered text
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"", centered_text, ""})

    vim.bo[buf]['modifiable'] = false

    local win = vim.api.nvim_open_win(buf, true, opts)

    vim.wo[win]['winhl'] ='Normal:AskScreenText,FloatBorder:AskScreenBorder'

    local function close_window(answer)
        vim.api.nvim_win_close(win, true)
        if answer == 'y' then
            source_rc("rc.lua")
        end
    end

    local disable_keys = { '-', 'h', 'l', 'j', 'k', 'g', 'G' }
    for _, key in ipairs(disable_keys) do
        vim.api.nvim_buf_set_keymap(buf, 'n', key, '<Nop>', { nowait = true, noremap = true, silent = true })
    end

    vim.api.nvim_buf_set_keymap(buf, 'n', 'y', '', {
        nowait = true, noremap = true, silent = true,
        callback = function() close_window('y') end
    })

    vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', '', {
        nowait = true, noremap = true, silent = true,
        callback = function() close_window('y') end
    })

    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '', {
        nowait = true, noremap = true, silent = true,
        callback = function() close_window('q') end
    })

    vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '', {
        nowait = true, noremap = true, silent = true,
        callback = function() close_window('q') end
    })
end

vim.api.nvim_create_user_command('SourceScreen', create_ask_screen, {})


local group = vim.api.nvim_create_augroup("project_rc", {clear=true})
vim.api.nvim_create_autocmd("VimEnter",{
    group=group,
    callback=function ()
        local matches = vim.fn.filereadable("./rc.lua")
        if matches == 1 then
            vim.cmd("SourceScreen")
        end
    end
})

