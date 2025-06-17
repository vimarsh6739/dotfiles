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
  {
    'Olical/conjure',
    ft = { 'racket', 'python', 'julia' },
    lazy = true,
    init = function()
      -- Set configuration options here
      -- Uncomment this to get verbose logging to help diagnose internal Conjure issues
      -- This is VERY helpful when reporting an issue with the project
      -- vim.g["conjure#debug"] = true
    end,
  },
}

-- LSP setup for MLIR
-- local manual_servers = {
--   mlir_lsp_server = {
--     filetypes = { 'mlir' },
--     cmd = { '/home/vimarsh6739/llvm-project/build/bin/mlir-lsp-server' },
--     root_dir = require('lspconfig.util').find_git_ancestor,
--     single_file_support = true,
--   },
--   stablehlo_lsp_server = {
--     filetypes = { 'mlir' },
--     cmd = { '/home/vimarsh6739/higher-order/stablehlo/build/bin/stablehlo-lsp-server' },
--     root_dir = require('lspconfig.util').find_git_ancestor,
--     single_file_support = true,
--   },
-- }
--
-- -- Setup neovim lua configuration
-- require('neodev').setup()
--
-- -- Add this before your manual_servers setup
-- local lspconfig = require 'lspconfig'
-- local configs = require 'lspconfig.configs'
--
-- -- Register the custom server configuration
-- if not configs.stablehlo_lsp_server then
--   configs.stablehlo_lsp_server = {
--     default_config = {
--       cmd = { '/home/vimarsh6739/higher-order/stablehlo/build/bin/stablehlo-lsp-server' },
--       filetypes = { 'mlir' },
--       root_dir = lspconfig.util.find_git_ancestor,
--       single_file_support = true,
--     },
--     docs = {
--       description = 'StableHLO LSP server',
--       default_config = {
--         root_dir = [[root_pattern(".git")]],
--       },
--     },
--   }
-- end
--
-- -- Setup the manual servers
-- for server_name, server_settings in pairs(manual_servers) do
--   require('lspconfig')[server_name].setup {
--     capabilities = capabilities,
--     on_attach = on_attach,
--     filetypes = server_settings.filetypes,
--     cmd = server_settings.cmd,
--     root_dir = server_settings.root_dir,
--     single_file_support = server_settings.single_file_support,
--   }
-- end

-- vim: ts=2 sts=2 sw=2 et
