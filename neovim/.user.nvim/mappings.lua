local sp = require('snacks.picker')
local sf = require('shared.functions')
local ext = require('shared.extensions')
local wk = require('which-key')

wk.add({
    -- Clearing search
    { '<leader>cl', '<cmd>noh<cr>' },

    -- Pane navigation
    { '<leader>p', '<C-W>w' },

    { '<Space>', '<nop>' },
    { '<C-k>', '<nop>' },

    -- Fast saving
    { '<leader>w', ':<C-u>silent update<cr>' },

    -- Make j and k behave like they should for wrapped lines
    { 'j', 'gj' },
    { 'k', 'gk' },

    -- Buffer navigation keybinds
    { '<leader>k', function() require('snacks.bufdelete').delete({ wipe = true }) end },
    { '<leader>b', sf.alt_buf_with_fallback },

    -- Quickfix
    { '<leader>q', function() require('quicker').toggle() end },

    { '<leader>n', ext.narrow_to_function },

    -- Don't lose visual selection with < >
    { '<', '<gv', mode = { 'x' } },
    { '>', '>gv', mode = { 'x' } },

    -- Format
    { '<leader>f', ':Neoformat<cr>', mode = { 'n', 'v' } },

    -- Picker
    { '<leader><space>', function() sp.buffers({ formatters = { file = { filename_first = true } } }) end },
    { '<leader>sf', function() sp.files({ hidden = true }) end },
    { '<leader>se', function ()
        sp.explorer({
            tree = true,
            layout = { preset = 'default' },
        })
    end },
    { '<leader>sg', sp.grep },
    { '<leader>sr', sp.recent },
    { '<leader>sR', sp.resume },
    { '<leader>sd', function() vim.diagnostic.setqflist({ open = true }) end },
    { '<leader>sD', function() wk.show({ keys = '<leader>D' }) end },
    { '<leader>e', ext.snacks_find_file },
    { '<M-x>', sp.commands },

    -- Help
    { '<C-h>f', sp.help },
    { '<C-h>k', sp.keymaps },

    -- Terminal
    { '<Esc>', '<C-\\><C-n>', mode = { 't' } },
    { '<leader>T', sf.open_toggle_term },

    -- Git
    { '<leader>G', function() require('neogit').open({ cwd = sf.get_buf_dir() }) end },
    { '<leader>B', require('snacks.git').blame_line },
})
