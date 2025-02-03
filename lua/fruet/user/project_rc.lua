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

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"Do you want to source", "the project file? (y/q)"})

    local win = vim.api.nvim_open_win(buf, true, opts)

    local function close_window(answer)
        vim.api.nvim_win_close(win, true)
        if answer == 'y' then
            source_rc("rc.lua")
        end
    end

    vim.api.nvim_buf_set_keymap(buf, 'n', 'y', '', {
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

vim.api.nvim_create_user_command('SourceSreen', create_ask_screen, {})


local group = vim.api.nvim_create_augroup("project_rc", {clear=true})
vim.api.nvim_create_autocmd("VimEnter",{
    group=group,
    callback=function ()
        local matches = vim.fs.find("rc.lua", {
            path = vim.fn.getcwd(),
            depth = 1,
            hidden = true,
        })
        if matches ~= nil and #matches > 0 then
            vim.cmd("SourceSreen")
        end
    end
})

