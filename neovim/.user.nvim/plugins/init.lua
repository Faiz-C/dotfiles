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
  -- Disable lsp_signature so that Noice can handle it
  {
    "ray-x/lsp_signature.nvim",
    enabled = false
  },

  -- Tokyo Night (Night) Theme
  {
    "folke/tokyonight.nvim",
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
            init_open_folds = "auto",
            icon_preset = "basic",
            folds = true,
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

  -- Telescope
  -- Borrowed from https://github.com/nvim-lua/kickstart.nvim
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('telescope').setup {
        defaults = {
          preview = {
            buffer_previewer_maker = function(filepath, bufnr, opts)
              local opts = opts or {}
              local filepath = vim.fn.expand(filepath)
              local max_bytes = 10000

              vim.loop.fs_stat(
                filepath,
                function(_, stat)
                  if not stat or stat.size > max_bytes then
                    return
                  else
                    require('telescope.previewers').buffer_previewer_maker(filepath, bufnr, opts)
                  end
                end
              )
            end
          },
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
            },
         },
         vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '-u' -- ignore binaries
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

      vim.keymap.set('n', '<leader>sr', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
      vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

      -- LSP
      vim.keymap.set('n', '<leader>gu', require('telescope.builtin').lsp_references, { desc = '[G]oto [U]sages' })
      vim.keymap.set('n', '<leader>gs', require('telescope.builtin').lsp_document_symbols, { desc = '[G]oto [S]ymbols' })
      vim.keymap.set('n', '<leader>gws', require('telescope.builtin').lsp_workspace_symbols, { desc = '[G]oto [W]orkspace [S]ymbols' })
      vim.keymap.set('n', '<leader>gd', require('telescope.builtin').lsp_definitions, { desc = '[G]oto [W]orkspace [S]ymbols' })
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
      "nvim-tree/nvim-web-devicons"
    },
    config = function()
      require('telescope').load_extension('file_browser')
      vim.keymap.set('n', '<leader>sj', '<cmd>Telescope file_browser<cr>', { noremap = true })
    end
  },

  -- Noice (Experimental)
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      "nvim-treesitter/nvim-treesitter",
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
          view = "notify",
        },

        routes = {
          {
            filter = {
              event = "msg_show",
              kind = "",
              find = "written"
            },
            view = "mini"
          },
          {
            filter = {
              event = "msg_show",
              kind = "",
              find = "line"
            },
            skip = true
          }
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

      vim.keymap.set({"n", "i", "s"}, "<c-j>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<c-j>"
          end
        end,
        { silent = true, expr = true }
      )

      vim.keymap.set({"n", "i", "s"}, "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<c-b>"
          end
        end,
        { silent = true, expr = true }
      )
    end
  },

  -- Nvim Tree
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      "nvim-tree/nvim-web-devicons"
    },
    config = function()

      -- Taken from the recipes section of the nvim-tree github repo
      local HEIGHT_RATIO = 0.8  -- You can change this
      local WIDTH_RATIO = 0.5   -- You can change this too

      require('nvim-tree').setup({
        on_attach = nvim_tree_on_attach,
        view = {
          float = {
            enable = true,
            open_win_config = function()
              local screen_w = vim.opt.columns:get()
              local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
              local window_w = screen_w * WIDTH_RATIO
              local window_h = screen_h * HEIGHT_RATIO
              local window_w_int = math.floor(window_w)
              local window_h_int = math.floor(window_h)
              local center_x = (screen_w - window_w) / 2
              local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
              return {
                border = 'rounded',
                relative = 'editor',
                row = center_y,
                col = center_x,
                width = window_w_int,
                height = window_h_int,
              }
            end,
        },
        width = function()
          return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
        end,
        },
      })
      vim.keymap.set('n', '<leader>t', '<cmd>NvimTreeToggle<cr>', { noremap = true })
    end
  },

  -- Nvim Projects
  {
    'ahmedkhalf/project.nvim',
    dependencies = {
      "nvim-tree/nvim-tree.lua"
    },
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
    ft = "norg",
    lazy = true,
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

  -- Nvim Bufferline (tabs)
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
