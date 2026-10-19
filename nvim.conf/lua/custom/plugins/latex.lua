return {
  {
    'lervag/vimtex',
    -- VimTeX must be available when filetype detection and inverse search run.
    lazy = false,
    init = function()
      vim.g.tex_flavor = 'latex'
      vim.g.vimtex_compiler_method = 'latexmk'
      vim.g.vimtex_fold_enabled = 1
      -- Keep typing shortcuts in our personal LuaSnip files instead.
      vim.g.vimtex_imaps_enabled = 0
      -- Show errors without taking focus away from the document.
      vim.g.vimtex_quickfix_mode = 2

      if vim.fn.has 'macunix' == 1 then
        vim.g.vimtex_view_method = 'skim'
        vim.g.vimtex_view_skim_activate = 0
        -- Refresh on compilation, but keep the reader's current PDF position.
        vim.g.vimtex_view_skim_sync = 0
      end
    end,
  },
}
