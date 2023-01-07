local use = require('packer').use

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
  branch = '0.1.x',
  requires = { { 'nvim-lua/plenary.nvim' } },
  config = function()
    require('telescope').setup {
      defaults = {
        mappings = {
          n = {
            ['d'] = require('telescope.actions').delete_buffer,
          },
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
          },
        },
        file_ignore_patterns = {
          "^.git/",
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          no_ignore = false,
        },
      },
      extensions = {
        file_browser = {
          hidden = true,
        },
      },
    }

    vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
    vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
  end
}

-- Telescope Fzf Native
-- Borrowed from https://github.com/nvim-lua/kickstart.nvim
use { 
  'nvim-telescope/telescope-fzf-native.nvim', 
  run = 'make', 
  cond = vim.fn.executable 'make' == 1,
  config = function()
    require('telescope').load_extension('fzf') 
  end
}

-- Telescope File Browser
use {
  "nvim-telescope/telescope-file-browser.nvim",
  requires = {
    'nvim-tree/nvim-web-devicons', -- optional, for file icons
  },
  config = function()
    require('telescope').load_extension('file_browser')
    vim.keymap.set('n', '<leader>sj', '<cmd>Telescope file_browser<cr>', { noremap = true })
  end
}

-- Nvim Tree
use {
  'nvim-tree/nvim-tree.lua',
  requires = {
    'nvim-tree/nvim-web-devicons', -- optional, for file icons
  },
  config = function()
    require('nvim-tree').setup({
      view = {
        adaptive_size = true,
        mappings = {
          list = {
            { key = "u", action = "dir_up" },
          },
        },
      },
    })
    vim.keymap.set('n', '<leader>t', '<cmd>NvimTreeToggle<cr>', { noremap = true })
  end
}

-- Nvim Projects
use {
  'ahmedkhalf/project.nvim',
  config = function()
    require('project_nvim').setup {
      show_hidden = true,
      scope_chdir = 'win',
    }

    require('nvim-tree').setup({
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
      },
    })

    require('telescope').load_extension('projects')
    vim.keymap.set('n', '<leader>sp', '<cmd>Telescope projects<cr>', { noremap = true })
  end
}

-- Nvim Neorg
use {
  "nvim-neorg/neorg",
  run = ":Neorg sync-parsers", -- This is the important bit!
  config = function()
    require("neorg").setup {
      load = {
        ["core.defaults"] = {},
        ["core.norg.dirman"] = {
          config = {
            workspaces = {
              notes = "~/org/notes",
            }
          }
        }
      }
    }
  end
}

-- Nvim Nabla (Scientific Notation)
use {
  'jbyuki/nabla.nvim'
}

-- Nvim Zen Mode
use {
  "folke/zen-mode.nvim",
  config = function()
    require("zen-mode").setup {
      width = .95
    }
    vim.keymap.set('n', '<leader>z', '<cmd>ZenMode<cr>', { noremap = true })
  end
}

-- Nvim Bufferline
use {
  'akinsho/bufferline.nvim', 
  tag = "v3.*", 
  requires = 'nvim-tree/nvim-web-devicons',
  config = function()
    require('bufferline').setup {}
  end
}

-- Nvim Workspaces (lightweight alternative to Projects)
-- use {
--  'natecraddock/workspaces.nvim',
--  config = function()
--    require("workspaces").setup({
--      cd_type = "local",
--      hooks = {
--        open = { "NvimTreeOpen", "Telescope file_browser" },
--      }
--    })
--    vim.keymap.set('n', '<leader>wo', '<cmd>WorkspacesOpen<cr>', { noremap = true })
--  end
-- }

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

