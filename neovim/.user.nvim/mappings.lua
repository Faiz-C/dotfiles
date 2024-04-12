local fzf = require('fzf-lua')

require('legendary').keymaps({
  { '<Space>', '<nop>' },
  { '<C-k>', '<nop>' },

  -- Fast saving
  { '<leader>w', ':<C-u>silent update<cr>' },

  -- Make j and k behave like they should for wrapped lines
  { 'j', 'gj' },
  { 'k', 'gk' },

  -- Buffer navigation keybinds
  { '<leader>k', '<cmd>bd<cr>' },
  { '<leader>n', narrow_to_function },
  { '<leader>l', '<cmd>bn<cr>' },
  { '<leader>h', '<cmd>bp<cr>' },

  -- Don't lose visual selection with < >
  { '<', '<gv', mode = { 'x' } },
  { '>', '>gv', mode = { 'x' } },

  -- Fzf
  { '<M-x>', fzf.commands },

  -- Clearing search
  { '<leader>cl', '<cmd>noh<cr>' },

  -- Pane navigation
  { '<leader>p', '<C-W>w' },

  -- Help
  { '<C-h>k', '<cmd>Legendary<cr>' },

  -- Terminal
  { '<Esc>', '<C-\\><C-n>', mode = { 't' }},
  { '<leader>T', open_toggle_term }
})

