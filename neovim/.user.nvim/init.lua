function user_install_plugins()
  return require('plugins')
end

function user_config()
  require('options')
  require('mappings')
end

function user_on_lsp_attach()
  local map_opts = { buffer = true }
  local fzf = require('fzf-lua')

  require('legendary').keymaps({
      { 'K', vim.lsp.buf.hover, opts = map_opts },
      { 'gi', fzf.lsp_implementations, opts = map_opts },
      { '<C-k>', vim.lsp.buf.signature_help, opts = map_opts },
      { 'gr', fzf.lsp_references, opts = map_opts },
      { 'E', vim.diagnostic.goto_prev, opts = map_opts },
      { 'e', vim.diagnostic.goto_next, opts = map_opts },
      { '<leader>f', vim.lsp.buf.format, opts = map_opts },
      { '<A-cr>', vim.lsp.buf.code_action, opts = map_opts },
      { 'gR', vim.lsp.buf.rename, opts = map_opts },
  })
end

user_lsp_overrides = {
  pylsp = {
    settings = {
      pylsp = {
        plugins = {
          pycodestyle={
            ignore={'E501', 'W391'},
            indentSize=2,
          },
        },
      },
    },
  },
}
