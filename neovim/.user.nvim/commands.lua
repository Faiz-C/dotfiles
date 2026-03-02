local fn = require("functions")

vim.api.nvim_create_user_command(
  "SnacksExplore",
  function(opts)
    local dir = (opts.args ~= "" and vim.fn.expand(opts.args)) or vim.fn.getcwd()
    vim.notify("Opts " .. opts.args)
    fn.ExploreDirectory(dir)
  end,
  {
    nargs = "?",
    complete = "dir"
  }
)
