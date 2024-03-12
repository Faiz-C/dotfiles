return require("telescope").register_extension {
  setup = function (ext_config, config)
    -- no setup required for this one
  end,
  exports = {
    colors = require("colors").colors
  }
}
