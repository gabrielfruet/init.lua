local map = vim.keymap.set
local tlscp = require('telescope.builtin')
local noremap = { noremap = true }

map('n', '<leader>fg', function()
    tlscp.grep_string()
end, noremap)

map('n', '<C-p>', function()
    tlscp.find_files()
end, noremap)

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
require("telescope").load_extension("ui-select")
