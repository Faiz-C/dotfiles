local fzf = require('fzf-lua')

require('legendary').keymaps({

  -- Buffer navigation keybinds
  { '<C-x>k', function() require('bufdelete').bufwipeout(0) end },
  { '<C-x>b', alt_buf_with_fallback },

  -- Make j and k behave correctly for wrapped lines
  { 'j', 'gj' },
  { 'k', 'gk' },

  -- Fzf
  { '<M-x>', fzf.commands },
  { '<C-x>m', fzf.buffers },
  { '<C-h>f', fzf.help_tags }

})
