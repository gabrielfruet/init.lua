local bufops = require(COMMA_PATH .. 'bufops')

local lang_command = {
    rust = function() return 'cargo run' end;
    python = function(fname) return ('python ' .. fname) end;
}

local commands = {
    rust={
        filetype='rust',
        cmd='cargo run'
    };
    python={
        filetype='python',
        callback=function(bufnr)
            local fpath = vim.api.nvim_buf_get_name(bufnr)
            return 'python ' .. fpath
        end
    };
    make={
        callback=function(bufnr)
            local makepath = vim.fs.find('Makefile',{
                upward=true,
                stop=vim.loop.os_homedir(),
                path=vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
            })
            local makecmd = {}
            for i,mkpath in ipairs(makepath) do
                makecmd[i] = 'make -f ' .. mkpath
            end
            return makecmd
        end
    },
    bash={
        filetype='sh',
        callback=function (bufnr)
            local fpath = vim.api.nvim_buf_get_name(bufnr)
            return fpath
        end
    }
}

local function available_commands(bufnr)
    local matched = {}
    for k,v in pairs(commands) do
        if v.filetype == nil or v.filetype == vim.filetype.match({buf=bufnr}) then
            vim.print(matched)
            if v.callback ~= nil then
                local cmd = v.callback(bufnr)
                if cmd ~= nil then
                    table.insert(matched, cmd)
                end
            end

            if v.cmd ~= nil and type(v.cmd) == 'string' then
                table.insert(matched, v.cmd)
            end

        end
    end

    vim.print(matched)

    return vim.tbl_flatten(matched)
end

local function get_command(filepath, lang)
    local create_command = lang_command[lang]
    if create_command == nil then
        return nil
    end
    return create_command(filepath)
end

local function remove_filtered(tbl, filter)
    local i = 1
    while i <= #tbl do
        if filter(tbl[i]) then
            table.remove(tbl, i)
        else
            i = i + 1
        end

    end
end

local function buf_on_output(bufnr, winhan)
    return  function (chan_id, data, name)
        if data then
            -- This is done because `\r` creates a `^M` character that is not wanted
            -- The solution sees to be substituting the character for ` `
            -- As substituting it with a empty string just skips the line
            -- We dont explicitly need to use `\n`.
            for i = 1, #data do
                data[i] = string.gsub(data[i], '\r', ' ')
            end
            remove_filtered(data, function(v) return v == "" end)
            vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)

            if winhan ~= nil then
                vim.api.nvim_win_set_cursor(winhan, {vim.api.nvim_buf_line_count(bufnr), 0})
            end
        end
    end
end

local function get_colors_from_highlight_group(group_name)
    local hl_id = vim.api.nvim_get_hl_id_by_name(group_name)
    return vim.api.nvim_get_hl(hl_id)
end

local function override_hl(ns_id, src, dst)
    local srchl = vim.api.nvim_get_hl(0, {name=src})
    vim.api.nvim_set_hl(ns_id, dst, srchl)
end

--- @param bufnr integer
--- @param opts table
local function buffer_to_floating_window(bufnr, opts)
    local win_width = vim.api.nvim_win_get_width(0)
    local win_height = vim.api.nvim_win_get_height(0)

    local scale = 0.5
    if opts.scale ~= nil then scale = opts.scale end

    local height = math.floor(win_height * scale)
    local width = math.floor(win_width * scale)

    local col = math.floor((win_width - width )/2)
    local row = math.floor((win_height - height )/2)

    local buf_name = 'Unnamed'
    if opts.buf_name ~= nil then buf_name = opts.buf_name end

    local winopts = {
        title=buf_name,
        relative='win',
        width=width,
        height=height,
        col=col,
        row=row,
        anchor='NW',
        style='minimal',
        border='rounded'
    }
    local winhan = vim.api.nvim_open_win(bufnr, true, winopts)

    local ns_name = 'Autorun'
    local bgns = vim.api.nvim_create_namespace(ns_name)

    local border_normal_float_hl = {
        none='AutorunNone',
        rounded='AutorunRounded',
        solid='AutorunSolid'
    }

    local border_floatborder_hl = {
        none='AutorunNoneFloatBorder',
        rounded='AutorunRoundedFloatBorder',
        solid='AutorunSolidFloatBorder'
    }

    override_hl(bgns, border_normal_float_hl[winopts.border], 'NormalFloat')
    override_hl(bgns, border_floatborder_hl[winopts.border], 'FloatBorder')

    vim.api.nvim_win_set_hl_ns(winhan, bgns)

    vim.bo.bufhidden = "delete"
    vim.bo.modifiable = true
    --
    return winhan
end

--- @param cmd string
--- @param bufnr integer
local function run_command(cmd, bufnr)
    local buf_name = cmd

    local winhan = buffer_to_floating_window(bufnr, {
        buf_name = buf_name
    })

    local job_id = vim.fn.jobstart(cmd, {
        on_stdout = buf_on_output(bufnr, winhan),
        on_stderr = buf_on_output(bufnr, winhan),
        on_exit = function(id, code, event)
            print(event)
        end,
        stdout_buffered = false,
        pty=true,
        stdin='pipe'
    })

    local only_clear = {clear=true}
    local stop_job_on_buf_deletion = vim.api.nvim_create_augroup('StopJobAfterBufDelete', only_clear)

    vim.api.nvim_create_autocmd('BufDelete', {
        group=stop_job_on_buf_deletion,
        buffer=bufnr,
        callback=function ()
            vim.fn.jobstop(job_id)
        end
    })
end

local function show_error(msg)
    vim.api.nvim_echo({{msg, 'ErrorMsg'}}, false, {})
end

local function autorun()
    local available_cmds = available_commands(0)

    local bufnr = bufops.get_output_buffer()

    vim.keymap.set('n', 'q', function()
        vim.api.nvim_buf_delete(bufnr, {})
    end, { noremap = true, silent = true, buffer=bufnr})

    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-r>', '', { noremap = true, silent = true })


    if #available_cmds < 1 then
        show_error('No command available')
        return
    elseif #available_cmds == 1 then
        run_command(available_cmds[1], bufnr)
    else
        vim.ui.select(available_cmds, {
            prompt='What command you want to run?'
        }, function(cmd)
                if cmd ~= nil and type(cmd) == 'string' then
                    run_command(cmd, bufnr)
                else
                    show_error('Didn`t choose any')
                end
            end)
    end
end


return {
    run = function ()
        vim.api.nvim_create_user_command('AutoRun', function() autorun() end, {})
        vim.api.nvim_create_user_command('AutoRunSetOutBuf', function() bufops.set_ouptut_buffer() end, {})
        vim.keymap.set("n", "<C-r>", autorun , {noremap=true})
    end
}

