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
end

local checkout = find_checkout()
local installed_server = vim.fn.expand '~/.local/bin/mlir-lsp-server'
local server = installed_server

if checkout then
  local development_server = checkout .. '/bazel-bin/mlir-lsp-server'
  if vim.fn.executable(development_server) == 1 then
    server = development_server
  end
end

local plugin = {
  lazy = false,
  build = vim.fn.executable(server) ~= 1 and './install.sh' or false,
  dependencies = {
    'saghen/blink.cmp',
  },
  config = function()
    require('mlir_lsp').setup {
      lsp = {
        cmd = { server },
        capabilities = require('blink.cmp').get_lsp_capabilities(),
      },
    }
  end,
}

if checkout then
  plugin.name = 'mlir-lsp'
  plugin.dir = checkout
else
  plugin[1] = 'vimarsh6739/mlir-lsp'
end

return {
  plugin,
}

-- vim: ts=2 sts=2 sw=2 et
