CONFIG_PATH = vim.fn.stdpath('config')

local function require_and_list_modules(path)
    print(path)
    local handle, err = vim.loop.fs_scandir(path);
    if not handle then
        print("Error scanning directory: " .. err)
        return
    end
    while true do
        local filename,type = vim.loop.fs_scandir_next(handle)
        if not filename then return end
        print(filename)
        local filepath = path .. '/' .. filename
        if type == 'directory' then
            print('im a directory')
        elseif type == 'file' and filename:match("%.lua$") then
            print('im a lua file')
        end
    end
end

return {
    load = require_and_list_modules
}
