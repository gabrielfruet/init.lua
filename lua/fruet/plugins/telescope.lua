return {
    "nvim-telescope/telescope.nvim",
    config = function ()
        local map = vim.keymap.set

        local tlscp = require('telescope.builtin')
        local noremap = { noremap = true }

        map('n', '<C-t>', tlscp.builtin, noremap)
        map('n', '<leader>fg', tlscp.grep_string, noremap)
        map('n', '<C-p>', tlscp.find_files, noremap)
        map('n', '<leader>ts', tlscp.treesitter, noremap)
        map('n', '<leader>ws', tlscp.lsp_dynamic_workspace_symbols, noremap)
        map('n', '<leader>vvd', tlscp.diagnostics, noremap)
        --map('n', '<leader>ts', tlscp.treesitter, noremap)

        require('telescope').setup {
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown {
                        -- even more opts
                    },

                    -- pseudo code / specification for writing custom displays, like the one
                    -- for "codeactions"
                    specific_opts = {
                        --   [kind] = {
                        --     make_indexed = function(items) -> indexed_items, width,
                        --     make_displayer = function(widths) -> displayer
                        --     make_display = function(displayer) -> function(e)
                        --     make_ordinal = function(e) -> string
                        --   },
                        --   -- for example to disable the custom builtin "codeactions" display
                        --      do the following
                        codeactions = true,
                    }
                }
            }
        }
    end
}
