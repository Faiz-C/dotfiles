local use = require('packer').use

-- Night Owl Theme
-- use { 'Julpikar/night-owl.nvim',
--  config = function()
--    vim.cmd('colorscheme night-owl')
--  end
-- }

-- Nightfox Carbonfox Theme
--use {
--  'EdenEast/nightfox.nvim',
--  config = function()
--    vim.cmd('colorscheme carbonfox')
--  end
--}

-- Tokyo Night (Night) Theme
use {
  'folke/tokyonight.nvim',
  config = function()
    require('tokyonight').setup({
      style = "night"
    })
    vim.cmd('colorscheme tokyonight-night')
  end
}

-- Telescope
-- Borrowed from https://github.com/nvim-lua/kickstart.nvim
use {
  'nvim-telescope/telescope.nvim', 
  tag = '0.1.0',
  requires = { {'nvim-lua/plenary.nvim'} },
  config = function()
    require('telescope').setup {
      defaults = {
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
          },
        },
      },
    }

    pcall(require('telescope').load_extension, 'fzf')

    vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
    vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer]' })

    vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
  end
}

use {
  "nvim-telescope/telescope-file-browser.nvim",
  config = function()
    require('telescope').load_extension 'file_browser'
    vim.keymap.set('n', '<leader>fb', ':Telescope file_browser<CR>', { noremap = true })
  end
}


