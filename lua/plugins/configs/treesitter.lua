local settings = require("core.settings")
local options = {
  ensure_installed = {
    settings.treesitter_ensure_installed,
  },
  highlight = {
    enable = true,
    use_languagetree = true,
  },

  indent = { enable = true },
}

return options
