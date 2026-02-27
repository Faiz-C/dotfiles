local selectedTheme = os.getenv("NEOVIM_THEME") or "tokyonight"

local themes = {
  ["tokyonight"] = {
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
  ["kanagawa"] = {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme kanagawa]])
    end
  },
  ["nordic"] = {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nordic").load()
      vim.cmd([[colorscheme nordic]])
    end
  },
  ["ayu"] = {
    "Shatur/neovim-ayu",
    lazy = false,
    priority = 1000,
    config = function()
      require("ayu").setup({
        mirage = true,
        overrides = {}
      })
      vim.cmd([[colorscheme ayu]])
    end

  }
}

return {
  -- Disable lsp_signature so that Noice can handle it
  {
    "ray-x/lsp_signature.nvim",
    enabled = false
  },

  {
    'saghen/blink.cmp',
    dependencies = 'rafamadriz/friendly-snippets',
    version = '*',
    event = { 'InsertEnter' },
    opts = {
      keymap = {
        preset = 'enter',
        ['<TAB>'] = { 'select_next', 'fallback' },
        ['<S-TAB>'] = { 'select_prev', 'fallback' },
      },

      signature = { enabled = true },

      completion = {
        menu = {
          draw = {
            padding = { 0, 1 },
            columns = { { 'kind_icon' }, { 'label' }, { 'source_name' } },
            components = {
              kind_icon = {
                text = function(ctx) return ' ' .. ctx.kind_icon .. ' ' .. ctx.icon_gap end,
              },
            },
          },
        },
        list = {
          selection = {
            preselect = true
          }
        },
        documentation = {
          auto_show = true,
        }
      },

      cmdline = {
        keymap = {
          ['<Tab>'] = { 'accept' },
          ['<CR>'] = { 'accept_and_enter', 'fallback' }
        },
        completion = {
          menu = {
            auto_show = true
          }
        }
      },

      sources = {
        providers = {
          cmdline = {
            min_keyword_length = function(ctx)
              -- when typing a command, only show when the keyword is 3 characters or longer
              if ctx.mode == 'cmdline' and string.find(ctx.line, ' ') == nil then return 3 end
              return 0
            end
          }
        }
      },

      opts_extend = { 'sources.default' }
    }
  },

  -- Loads selected theme as a plugin
  themes[selectedTheme],

  {
    "bngarren/checkmate.nvim",
    ft = "markdown",
    opts = {
      files = {
        "todo",
        "TODO",
        "todo.md",
        "TODO.md",
        "*.todo",
        "*.todo.md",
        "todo.neorg"
      },
    }
  },

  {
    "LintaoAmons/scratch.nvim",
    event = "VeryLazy",
  },

  -- Luarocks
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true
  },

  -- Neorg
  {
    "nvim-neorg/neorg",
    ft = "norg",
    dependencies = {
      "luarocks.nvim",
      "hrsh7th/nvim-cmp"
    },
    lazy = false,
    version = "*",
    config = true,
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
        }
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
      "smjonas/inc-rename.nvim"
    },
    config = function()
      require("inc_rename").setup {}

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
          },
          {
            filter = {
              event = "msg_show",
              kind = "",
              find = "CopilotChat"
            },
            view = "mini"
          },
        },

        presets = {
          bottom_search = false,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = true,
          lsp_doc_border = true,
        },
      }

      require("telescope").load_extension("noice")
      require("nvim-treesitter.config").setup {
        modules = {},
        ensure_installed = {
          "vim",
          "regex",
          "lua",
          "bash",
          "markdown",
          "markdown_inline",
          "kotlin",
          "c",
        },
        auto_install = true,
        sync_install = false,
        ignore_install = {},
      }

      vim.keymap.set("n", "<leader>r", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end, { expr = true })

      vim.keymap.set({ "n", "i", "s" }, "<c-j>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<c-j>"
          end
        end,
        { silent = true, expr = true }
      )

      vim.keymap.set({ "n", "i", "s" }, "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<c-b>"
          end
        end,
        { silent = true, expr = true }
      )
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

  -- Nvim Autopairs
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {}
    end
  },

}
