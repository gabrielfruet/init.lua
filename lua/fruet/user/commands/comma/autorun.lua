local bufops = require(COMMA_PATH .. 'bufops')

local lang_command = {
    rust = function() return 'cargo run' end;
    python = function(fname) return ('python ' .. fname) end;
}

local commands = {
    rust={
        filetype='rust',
        cmd={'cargo run'}
    };
    go = {
        filetype = 'go',
        callback = function()
            local gopaths = vim.fs.find('main.go',{
                upward=false,
                limit=10,
                path=vim.fn.getcwd()
            })
            local cmds = {}
            for _,gopath in pairs(gopaths) do
                local dirname = vim.fs.dirname(gopath:gsub(vim.fn.getcwd(), '.'))
                table.insert(cmds, {
                    string.format('go build -C %s -o main.o', dirname),
                    text_render=string.format('Go: build %s', dirname),
                    output={
                        'quickfix'
                    }
                })
            end
            return cmds
        end
    },
    python={
        filetype='python',
        callback=function()
            local fpath = vim.api.nvim_buf_get_name(0)
            return {
                'python ' .. fpath,
                output={
                    'split'
                }
            }
        end
    };
    make={
        callback=function()
            local function get_makefile_targets(makefile_path)
                local targets = {}
                local file = io.open(makefile_path, "r")

                if not file then
                    print("Makefile not found: " .. makefile_path)
                    return targets
                end

                for line in file:lines() do
                    local target = line:match("^([%w-_]+):")
                    if target then
                        table.insert(targets, target)
                    end
                end
        -- mouse is flickering
                file:close()

                return targets
            end

            local makepath = vim.fs.find('Makefile',{
                upward=true,
                stop=vim.loop.os_homedir(),
                path=vim.fn.getcwd()
            })
            local makecmd = {}
            for _,mkpath in pairs(makepath) do
                for _, target in pairs(get_makefile_targets(mkpath)) do
                    table.insert(makecmd, {
                        string.format('make %s -f %s', target, mkpath),
                        text_render=string.format('Make: make %s at %s', target, mkpath:gsub(vim.fn.getcwd(), '.')),
                        output={
                            'quickfix'
                        }
                    })
                end
            end
            return makecmd
        end
    },
    bash={
        filetype='sh',
        callback=function ()
            local fpath = vim.api.nvim_buf_get_name(0)
            return {
                fpath,
                output = {
                    'split'
                }
            }
        end
    }
}

local function to_quickfix(cmd)
    vim.cmd(string.format('cexpr system(\'%s\')', cmd))
    vim.cmd'copen'
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

local function buffer_to_bot_window(bufnr,opts)
    local win_width = vim.api.nvim_win_get_width(0)
    local win_height = vim.api.nvim_win_get_height(0)

    local scale = 0.2
    if opts.scale ~= nil then scale = opts.scale end

    local height = math.floor(win_height * scale)
    local width = math.floor(win_width * scale)

    local col = math.floor((win_width - width )/2)
    local row = math.floor((win_height - height )/2)

    local buf_name = 'Unnamed'
    if opts.buf_name ~= nil then buf_name = opts.buf_name end

    vim.cmd[[split]]
    vim.cmd[[wincmd j]]
    local winhan = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(winhan, bufnr)
    vim.api.nvim_win_set_height(winhan,height)

    vim.bo.bufhidden = "delete"
    vim.bo.modifiable = true
    --
    return winhan
end

local function buffer_to_winfn(cmd, winfn)
    local buf_name = cmd
    local bufnr = bufops.get_output_buffer()
    local winhan = winfn(bufnr, {buf_name=buf_name})

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

    vim.keymap.set('n', 'q', function()
        vim.api.nvim_buf_delete(bufnr, {})
    end, { noremap = true, silent = true, buffer=bufnr})

    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-r>', '', { noremap = true, silent = true })

    vim.api.nvim_create_autocmd('BufDelete', {
        group=stop_job_on_buf_deletion,
        buffer=bufnr,
        callback=function ()
            vim.fn.jobstop(job_id)
        end
    })
end

---@class CommandOptions
---@field cmd string
---@field output table
---@field text_render? string
local CommandOptions = {output={'split'}}

local CommandOptionsRunMethod = {
    quickfix=to_quickfix,
    float=function(cmd) return buffer_to_winfn(cmd, buffer_to_floating_window) end,
    split=function(cmd) return buffer_to_winfn(cmd, buffer_to_bot_window) end,
}

function CommandOptions:new(o)
    o = o or {}   -- create object if user does not provide one
    o.output = o.output or CommandOptions.output
    setmetatable(o, self)
    self.__index = self
    return o
end

function CommandOptions.wrap(o)
    if type(o[1]) == 'string' then
        return {CommandOptions:new(o)}
    else
        local tbl = {}
        for _,obj in pairs(o) do
            vim.list_extend(tbl, CommandOptions.wrap(obj))
        end
        return tbl
    end
end

function CommandOptions:exec()
    local method = self.output[1]
    CommandOptionsRunMethod[method](self[1])
end

---@class CommandBuilder
---@field filetype? string
---@field cmd? string
---@field callback? function
local CommandBuilder = {}

function CommandBuilder:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end

---@return CommandOptions[]
function CommandBuilder:get_commands()
    local matched = {}
    if self.filetype == nil or self.filetype == vim.bo.filetype then
        if self.callback ~= nil then
            local cmd = CommandOptions.wrap(self.callback())
            if cmd ~= nil then
                vim.list_extend(matched, cmd)
            end
        end

        if self.cmd ~= nil and type(self.cmd) == 'string' then
            table.insert(matched, CommandOptions:new(self.cmd))
        end
    end
    return matched
end


---@return CommandOptions[]
local function available_commands()
    local matched = {}
    for _,v in pairs(commands) do
        vim.list_extend(matched, CommandBuilder:new(v):get_commands())
    end

    return matched
end

local function get_command(filepath, lang)
    local create_command = lang_command[lang]
    if create_command == nil then
        return nil
    end
    return create_command(filepath)
end



--- @param cmd CommandOptions
local function run_command(cmd)
    cmd:exec()
end

local function show_error(msg)
    vim.api.nvim_echo({{msg, 'ErrorMsg'}}, false, {})
end

local function autorun()
    local available_cmds = available_commands()

    if #available_cmds < 1 then
        show_error('No command available')
        return
    elseif #available_cmds == 1 then
        run_command(available_cmds[1])
    else
        vim.ui.select(available_cmds, {
            prompt='What command you want to run?',
            ---@param item CommandOptions
            format_item = function (item)
                return item.text_render or item[1]
            end
        }, function(cmd)
                if cmd ~= nil then
                    run_command(cmd)
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

