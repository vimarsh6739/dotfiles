return {
  {
    'vimarsh6739/mlir-lsp',
    lazy = false,
    build = 'test -x "$HOME/.local/bin/mlir-lsp-server" || ./install.sh',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'saghen/blink.cmp',
    },
    config = function()
      require('mlir_lsp').setup {
        lsp = {
          capabilities = require('blink.cmp').get_lsp_capabilities(),
        },
      }
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
