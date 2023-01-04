local use = require('packer').use

-- Night Owl Theme
use {
  'Julpikar/night-owl.nvim',
  config = function()
    vim.cmd('colorscheme night-owl')
  end
}
