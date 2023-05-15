local function nvim_tree_on_attach(bufnr)
  local api = require('nvim-tree.api')


  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set('n', 'O', '', { buffer = bufnr })
  vim.keymap.del('n', 'O', { buffer = bufnr })
  vim.keymap.set('n', '<2-RightMouse>', '', { buffer = bufnr })
  vim.keymap.del('n', '<2-RightMouse>', { buffer = bufnr })
  vim.keymap.set('n', 'D', '', { buffer = bufnr })
  vim.keymap.del('n', 'D', { buffer = bufnr })
  vim.keymap.set('n', 'E', '', { buffer = bufnr })
  vim.keymap.del('n', 'E', { buffer = bufnr })

  vim.keymap.set('n', 'A', api.tree.expand_all, opts('Expand All'))
  vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
  vim.keymap.set('n', 'C', api.tree.change_root_to_node, opts('CD'))
  vim.keymap.set('n', 'P', function()
    local node = api.tree.get_node_under_cursor()
    print(node.absolute_path)
  end, opts('Print Node Path'))

  vim.keymap.set('n', 'Z', api.node.run.system, opts('Run System'))
  vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('UP'))
end

return {
  -- Tokyo Night (Night) Theme
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup({
        style = "night"
      })
      vim.cmd([[colorscheme tokyonight-night]])
    end
  },

  -- Nvim Neorg
  {
    "nvim-neorg/neorg",
    ft = "norg",
    build = ":Neorg sync-parsers", -- This is the important bit!
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.fs"] = {},
        ["core.presenter"] = {
          config = {
            zen_mode = "zen-mode"
          },
        },
        ["core.export"] = {},
        ["core.concealer"] = {
          config = {
            folds = false,
            width = "content",
            preset = "diamond",
          },
        },
        ["core.export.markdown"] = {},
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp"
          },
        },
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/notes",
            }
          }
        },
        ["core.manoeuvre"] = {},
      }
    }
  },

  -- Noice (Experimental)
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify"
    },
    config = function()
      require("noice").setup {
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },

        presets = {
          bottom_search = false,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = true,
        },
      }

      require("telescope").load_extension("noice")
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "vim",
          "regex",
          "lua",
          "bash",
          "markdown",
          "markdown_inline"
        }
      }

      vim.keymap.set("c", "<s-Enter>",
        function()
          require("noice").redirect(vim.fn.getcmdline())
        end,
        { desc = "Redirect Cmdline" }
      )

      vim.keymap.set({"n", "i", "s"}, "<c-j>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<c-f>"
          end
        end, 
        { silent = true, expr = true }
      )

      vim.keymap.set({"n", "i", "s"}, "<c-k>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<c-b>"
          end
        end,
        { silent = true, expr = true }
      )
    end
  },

  -- Telescope
  -- Borrowed from https://github.com/nvim-lua/kickstart.nvim
  {
    'nvim-telescope/telescope.nvim',
     tag = '0.1.1',
     dependencies = {
       'nvim-lua/plenary.nvim'
     },
     config = function()
       require('telescope').setup {
         defaults = {
           mappings = {
             i = {
               ['<C-u>'] = false,
               ['<C-d>'] = false,
             },
           },
           file_ignore_patterns = {
             "^[./]*.git/",
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
  },

  -- Telescope Fzf Native
  -- Borrowed from https://github.com/nvim-lua/kickstart.nvim
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    enabled = vim.fn.executable 'make' == 1,
    config = function()
      require('telescope').load_extension('fzf')
    end
  },

  -- Telescope File Browser
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    config = function()
      require('telescope').load_extension('file_browser')
      vim.keymap.set('n', '<leader>sj', '<cmd>Telescope file_browser<cr>', { noremap = true })
    end
  },

  -- Nvim Tree
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    config = function()
      require('nvim-tree').setup({
        on_attach = nvim_tree_on_attach,
        view = {
          adaptive_size = true,
        },
      })
      vim.keymap.set('n', '<leader>t', '<cmd>NvimTreeToggle<cr>', { noremap = true })
    end
  },

  -- Nvim Projects
  {
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
  },

  -- Nvim Nabla (Scientific Notation)
  {
    'jbyuki/nabla.nvim',
    config = function()
      vim.keymap.set('n', '<leader>n', require('nabla').toggle_virt)
    end
  },

  -- Nvim Zen Mode
  {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup {
        window = {
          width = .85
        }
      }
      vim.keymap.set('n', '<leader>z', '<cmd>ZenMode<cr>', { noremap = true })
    end
  },

  -- Nvim Bufferline
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('bufferline').setup {}
    end
  },

  -- Nvim Autopairs
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {}
    end
  },

}
