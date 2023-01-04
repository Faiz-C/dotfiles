function user_install_plugins()
  require('plugins')
end

function user_config()
  require('options')
  require('mappings')
end

user_lsp_overrides = {
}
