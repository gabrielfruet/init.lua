require('fruet.set')
require('fruet.lazy')
require('fruet.keymap')
require('fruet.telescope.keymap')
require('fruet.mason')
require('fruet.cmp')
require('fruet.lspsetup')
require('fruet.treesitter')

require('fruet.lualine')
require('fruet.theme.transparent')
require('fruet.theme.tokyonight')
require('fruet.commands.update')

vim.cmd("command! UpdateAll lua require('fruet.commands.update').update_plugins()")
vim.cmd("command! AutoRun lua require('fruet.autorun').run()")

local fg = '#202020'
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    --mappings = {
      --list = {
        --{ key = "u", action = "dir_up" },
      --},
    --},
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
require('bufferline').setup({
    options = {
        --separator_style = "slant",

        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                text_align ="center",
                separator = true,
                highlights = "NvimTreeNormal"
            }
        }
    },
    highlights = {
        separator = {
            fg = fg,
        },
        separator_visible = {
            fg = fg,
        },
        separator_selected = {
            fg = fg,
        },
    },
})
require('nvim-autopairs').setup()
require("luasnip.loaders.from_snipmate").lazy_load({paths = './snippets'})
