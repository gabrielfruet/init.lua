CONFIG_PATH = vim.fn.stdpath('config')
LUA_CONFIG_PATH = vim.fn.stdpath('config') .. '/lua/'

local function is_module(dirpath)
    local normpath = vim.fs.normalize(dirpath .. '/init.lua')
    return vim.fn.filereadable(normpath) == 1
end

MODULES_TABLE_OPTS = {
    recursive = true,
}

local function to_relative_module_name(path)
    return path:gsub(LUA_CONFIG_PATH, ''):gsub('/', '.'):gsub('.lua', '')
end

local function modules_table(path, opts)
    if opts == nil then opts = {} end
    local modules = {}
    local nopts = vim.tbl_extend("keep", opts, MODULES_TABLE_OPTS)

    local function add_modules(fpath)
        local handle, err = vim.loop.fs_scandir(fpath);
        if not handle then
            print("Error scanning directory: " .. err)
            return nil
        end
        while true do
            local filename,type = vim.loop.fs_scandir_next(handle)
            if not filename then break end

            local filepath = vim.fs.normalize(fpath .. '/' .. filename)

            if type == 'directory' then
                if is_module(filepath) then
                    modules[#modules+1] = to_relative_module_name(filepath)
                elseif nopts.recursive == true then
                    add_modules(filepath)
                end
            elseif type == 'file' and filename:match("%.lua$") then
                modules[#modules+1] = to_relative_module_name(filepath)
            end
        end
    end

    add_modules(path)
    return modules
end

REQUIRE_LOADER_DEFAULT = {
    enabled = true,
    run = function() end
}

local function require_loader(modules)
    for _,module in pairs(modules) do
        local cfg = require(module)
        if type(cfg) ~= 'table' then cfg = {} end
        local ncfg = vim.tbl_extend("keep", cfg, REQUIRE_LOADER_DEFAULT)
        if ncfg.enabled then
            --vim.print(module .. ' loaded and runned')
            ncfg.run()
        else
            --vim.print(module .. ' loaded and not runned')
        end
    end
end

local function load(module)
    local relpath = string.gsub(module, '%.', '/')
    local fullpath = vim.fs.normalize(CONFIG_PATH .. '/lua/' ..  relpath)
    local modules = modules_table(fullpath)
    require_loader(modules)
end


return {
    load = load
}
