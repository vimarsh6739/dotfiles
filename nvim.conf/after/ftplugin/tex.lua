-- Display long prose lines comfortably without changing the source wrapping.
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.spell = true
vim.opt_local.spelllang = 'en_us'

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '\nsetlocal wrap< linebreak< spell< spelllang<'
