local sp = require('snacks.picker')

local functions = {}

function functions.ExploreDirectory(dir, show_tree, preset)
  sp.explorer({
    cwd = dir or vim.fn.getcwd(),
    tree = show_tree or true,
    hidden = true,
    auto_close = true,
    layout = {
      preset = preset or "sidebar"
    }
  })
end

return functions
