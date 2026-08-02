local function find_checkout()
  local configured_path = vim.env.MLIR_LSP_DEV_PATH
  if configured_path and configured_path ~= '' then
    local path = vim.fs.normalize(vim.fn.fnamemodify(vim.fn.expand(configured_path), ':p'))
    if vim.uv.fs_stat(path .. '/lua/mlir_lsp/init.lua') then
      return path
    end
    error('MLIR_LSP_DEV_PATH is not an mlir-lsp checkout: ' .. path)
  end

  local candidates = {
    vim.fn.expand '~/hiord/mlir-lsp',
    '/mnt/vimarsh6739/hiord/mlir-lsp',
    vim.fn.expand '~/Projects/mlir-lsp',
  }

  for _, path in ipairs(candidates) do
    if vim.uv.fs_stat(path .. '/lua/mlir_lsp/init.lua') then
      return path
    end
  end

  error 'mlir-lsp development checkout not found; set MLIR_LSP_DEV_PATH'
end

local checkout = find_checkout()
local development_server = checkout .. '/bazel-bin/mlir-lsp-server'
local installed_server = vim.fn.expand '~/.local/bin/mlir-lsp-server'

return {
  {
    name = 'mlir-lsp',
    dir = checkout,
    lazy = false,
    build = 'test -x "$HOME/.local/bin/mlir-lsp-server" || ./install.sh',
    dependencies = {
      'saghen/blink.cmp',
    },
    config = function()
      require('mlir_lsp').setup {
        lsp = {
          cmd = {
            vim.fn.executable(development_server) == 1 and development_server or installed_server,
          },
          capabilities = require('blink.cmp').get_lsp_capabilities(),
        },
      }
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
