return {
    'mfussenegger/nvim-dap',
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "jay-babu/mason-nvim-dap.nvim",
        "nvim-neotest/nvim-nio"
    },
    config = function ()
        local dap = require('dap')
        local dapui = require("dapui")
        dapui.setup()
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end
        vim.keymap.set('n', '<leader>dt', dap.toggle_breakpoint, {})
        vim.keymap.set('n', '<leader>dc', dap.continue, {})

        require ('mason-nvim-dap').setup({
            ensure_installed = {'delve', 'stylua', 'debugpy'},
            handlers = {}, -- sets up dap in the predefined manner
        })
    end
}
