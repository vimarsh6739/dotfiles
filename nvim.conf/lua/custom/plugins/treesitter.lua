local parsers = {
  'cpp',
  'python',
  'julia',
  'lua',
  'rust',
  'cuda',
  'llvm',
  'haskell',
  'tablegen',
  'starlark',
  'gitcommit',
  'git_config',
  'gitignore',
  'latex',
  'make',
  'vim',
  'vimdoc',
}

local parser_aliases = {
  gitconfig = 'git_config',
  tex = 'latex',
  plaintex = 'latex',
  help = 'vimdoc',
}

local filetypes = vim.list_extend(vim.deepcopy(parsers), vim.tbl_keys(parser_aliases))

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').install(parsers)

      vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = function(event)
          local parser = parser_aliases[event.match] or event.match
          pcall(vim.treesitter.start, event.buf, parser)
        end,
      })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
