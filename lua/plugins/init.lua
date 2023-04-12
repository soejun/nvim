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
  },

  -- icons
  {
    "nvim-tree/nvim-web-devicons",
  },
   -- file managing , picker etc
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    init = function()
      require("utils.functions").load_mappings "nvimtree"
    end,
    opts = function()
      return require "plugins.configs.nvimtree"
    end,
    config = function(_, opts)
      require("nvim-tree").setup(opts)
      vim.g.nvimtree_side = opts.view.side
    end,
  },


  -- Load whichkey after all other gui
  {
    "folke/which-key.nvim",
    keys = {"<leader>", '"', "'", "`", "c", "v"},
    init = function ()
      require("utils.functions").load_mappings "whichkey"
    end,
    opts = function ()
      return require "plugins.configs.whichkey"
    end,
    config = function(opts)
      require("which-key").setup(opts)
    end,
  },
}

require("lazy").setup(default_plugins)

