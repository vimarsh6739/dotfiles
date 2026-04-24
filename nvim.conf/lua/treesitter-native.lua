local parser_root = vim.fn.stdpath 'config' .. '/parsers'
local target_filetypes = {
  cpp = 'cpp',
  python = 'python',
  julia = 'julia',
  lua = 'lua',
  rust = 'rust',
  cuda = 'cuda',
  haskell = 'haskell',
  tablegen = 'tablegen',
  starlark = 'starlark',
  gitcommit = 'gitcommit',
  git_config = 'git_config',
  gitconfig = 'git_config',
  gitignore = 'gitignore',
  latex = 'latex',
  tex = 'latex',
  plaintex = 'latex',
  make = 'make',
  vim = 'vim',
  vimdoc = 'vimdoc',
  help = 'vimdoc',
}

vim.opt.runtimepath:prepend(parser_root)

local notify_missing_parser = function(lang, err)
  local details = err and (' (' .. err .. ')') or ''
  vim.notify(
    ('Tree-sitter parser for %s is not available%s'):format(lang, details),
    vim.log.levels.WARN,
    { title = 'treesitter-native' }
  )
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = vim.tbl_keys(target_filetypes),
  callback = function(ev)
    local lang = target_filetypes[ev.match]
    local ok_add, loaded, err = pcall(vim.treesitter.language.add, lang)
    if not ok_add or not loaded then
      notify_missing_parser(lang, err)
      return
    end

    local ok_start, start_err = pcall(vim.treesitter.start, ev.buf, lang)
    if not ok_start then
      vim.notify(
        ('Failed to start Tree-sitter for %s (%s)'):format(lang, start_err),
        vim.log.levels.WARN,
        { title = 'treesitter-native' }
      )
    end
  end,
})

-- vim: ts=2 sts=2 sw=2 et
