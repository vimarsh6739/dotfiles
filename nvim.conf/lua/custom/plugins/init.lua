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
    ---@type AutoSession.config
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
  'tpope/vim-fugitive',
  {
    -- MLIR and TableGen syntax support
    name = 'mlir-tablegen-syntax',
    dir = vim.fn.stdpath 'config',
    priority = 1000,
    config = function()
      vim.g.markdown_fenced_languages = vim.list_extend(vim.g.markdown_fenced_languages or {}, { 'mlir', 'tablegen' })
    end,
  },
  -- {
  --   'Olical/conjure',
  --   ft = { 'racket', 'python', 'julia' },
  --   lazy = true,
  --   init = function()
  --     -- Set configuration options here
  --     -- Uncomment this to get verbose logging to help diagnose internal Conjure issues
  --     -- This is VERY helpful when reporting an issue with the project
  --     -- vim.g["conjure#debug"] = true
  --   end,
  -- },
  {
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      require('onedark').setup { style = 'darker' }
      require('onedark').load()
    end,
  },
  {
    -- Fennel tooling for incremental porting
    'Olical/nfnl',
    lazy = false,
  },
}

-- vim: ts=2 sts=2 sw=2 et
