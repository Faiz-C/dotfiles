local fzf = require('fzf-lua')

require('legendary').keymaps({
  { '<Space>', '<nop>' },

  -- Fast saving
  { '<leader>w', ':<C-u>silent update<cr>' },

  -- Make j and k behave like they should for wrapped lines
  { 'j', 'gj' },
  { 'k', 'gk' },

  -- Buffer navigation keybinds
  { '<leader>k', ':bd<cr>' },
  { '<leader>n', narrow_to_function },

  -- Don't lose visual selection with < >
  { '<', '<gv', mode = { 'x' } },
  { '>', '>gv', mode = { 'x' } },

  -- Format
  { '<leader>F', ':Neoformat<cr>', mode = { 'n', 'v' } },

  -- Fzf
  { '<leader>f', fzf.files },
  { '<leader>g', fzf.live_grep },
  { '<M-x>', fzf.commands },

  -- Help
  { '<C-h>f', fzf.help_tags },
  { '<C-h>k', '<cmd>Legendary<cr>' },
})
