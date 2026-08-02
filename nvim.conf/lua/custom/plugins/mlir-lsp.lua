return {
  {
    'vimarsh6739/mlir-lsp',
    lazy = false,
    build = './install.sh',
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
