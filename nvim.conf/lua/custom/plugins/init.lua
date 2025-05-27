-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
	{
		'rmagatti/auto-session',
		lazy = false,
		--enables autocomplete for opts
		---@module "auto-session"
		--- @type AutoSession.config
		opts = {
			auto_save = false,
			auto_restore = false,
			suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
		},
	},
	{
		'danymat/neogen',
		config = true,
		-- Uncomment next line if you want to follow only stable versions
		-- version = "*"
	},
}

-- vim: ts=2 sts=2 sw=2 et
