local function update_plugins()
    print("Updating plugins...")

    local update_commands = {
        "Lazy update",
        "MasonUpdate",
        "TsUpdate"
        -- Add more update commands as needed
    }

    for _, cmd in ipairs(update_commands) do
        local job = vim.fn.jobstart({'nvim', '--headless', '--noplugin', '-c', cmd, '-c', 'quitall'}, {
            on_exit = function(_, exit_code, _)
                if exit_code == 0 then
                    print(cmd .. " completed successfully")
                else
                    print(cmd .. " failed with exit code " .. exit_code)
                end
            end
        })
        vim.fn.jobwait({job}, -1) -- Wait for the job to finish
    end

    print("Plugins updated.")
end

vim.api.nvim_create_user_command('UpdateAll', update_plugins, {})

return {
}
