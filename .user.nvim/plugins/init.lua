local use = require('packer').use

-- Night Owl Theme
-- use { 'Julpikar/night-owl.nvim',
--  config = function()
--    vim.cmd('colorscheme night-owl')
--  end
-- }

-- Tokyo Night
use {
  'folke/tokyonight.nvim',
  config = function()
    require('tokyonight').setup({
      style = "night"
    })
    vim.cmd('colorscheme tokyonight-night')
  end
}

--use {
--  'EdenEast/nightfox.nvim',
--  config = function()
--    vim.cmd('colorscheme carbonfox')
--  end
--}

