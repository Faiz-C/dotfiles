local fzf = require('fzf-lua')

require('legendary').keymaps({
  { '<Space>', '<nop>' },

  -- Fast saving
  { '<leader>w', ':<C-u>silent update<cr>' },

  -- Make j and k behave like they should for wrapped lines
  { 'j', 'gj' },
  { 'k', 'gk' },

  -- Buffer navigation keybinds
  { '<leader>k', '<cmd>bd<cr>' },
  { '<leader>n', narrow_to_function },
  { '<leader>ll', '<cmd>bn<cr>' },
  { '<leader>hh', '<cmd>bp<cr>' },

  -- Don't lose visual selection with < >
  { '<', '<gv', mode = { 'x' } },
  { '>', '>gv', mode = { 'x' } },

  -- Format
  { '<leader>F', '<cmd>Neoformat<cr>', mode = { 'n', 'v' } },

  -- Fzf
  { '<M-x>', fzf.commands },

  -- Clearing search
  { '<leader>cl', '<cmd>noh<cr>' },

  -- Pane navigation
  { '<leader>p', '<C-W>w' },

  -- Help
  { '<C-h>k', '<cmd>Legendary<cr>' },
})
