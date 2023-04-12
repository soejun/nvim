---@diagnostic disable: different-requires
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"


local default_plugins = {
  "nvim-lua/plenary.nvim",
  {
    "svrana/neosolarized.nvim",
    lazy = false,
    dependencies =  {
      "tjdevries/colorbuddy.nvim"
    },
    opts = function ()
      return require "plugins.themes.neosolarized"
    end,
    config = function(opts)
      require("neosolarized").setup(opts)
    end,
  }
}

require("lazy").setup(default_plugins)

