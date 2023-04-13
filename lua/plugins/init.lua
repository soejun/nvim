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


  {
    "lukas-reineke/indent-blankline.nvim",
    init = function()
      require("utils.functions").lazy_load "indent-blankline.nvim"
    end,
    opts = function()
      return require("plugins.configs.indent-blankline")
    end,
    config = function(_, opts)
     vim.cmd [[highlight IndentBlanklineChar guifg=#0f3a45 gui=nocombine]]
     vim.cmd [[highlight IndentBlankineSpaceChar guifg=#0f3a45 gui=nocombine]]
     vim.cmd [[highlight IndentBlanklineContextChar guifg=#28535e gui=nocombine]]
     vim.cmd [[highlight IndentBlanklineContextStart guisp=#133e49 gui=nocombine]]
     require("utils.functions").load_mappings "blankline"
     require("indent_blankline").setup(opts) -- i have no idea why the original code differs like that
    end,
  },

  -- make sure to load nvim-treesitter after indent-blankline otherwise things will break
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      require("utils.functions").lazy_load "nvim-treesitter"
    end,
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return require "plugins.configs.treesitter"
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
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

