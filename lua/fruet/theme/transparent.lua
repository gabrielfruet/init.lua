--
--autocmd ColorScheme * highlight BufferLineFill guibg=none
--autocmd ColorScheme * highlight BufferLineBackground guifg=#7a7c9e
--autocmd ColorScheme * highlight BufferLineBufferSelected guifg=white gui=none
require("transparent").setup({
    extra_groups = {}
    --    exclude = {
    --}, -- table: groups you don't want to clear
})
