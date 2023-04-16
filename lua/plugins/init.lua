---@diagnostic disable: different-requires
-- TODO: Seriously, we need a way better way to organize this and make it maintainable jesus christ
-- we can start categorizng thngs, into ui, lsp, quality of life

local default_plugins = {
  { "nvim-lua/plenary.nvim", lazy = false, priority = 1000 },
  {
    "svrana/neosolarized.nvim",
    lazy = false,
    dependencies = {
      "tjdevries/colorbuddy.nvim",
    },
    opts = function()
      return require("plugins.themes.svrana-neosolarized")
    end,
    config = function(opts)
      require("neosolarized").setup(opts)
    end,
  },
  -- icons
  {
    "nvim-tree/nvim-web-devicons",
  },

  {
    "folke/noice.nvim",
    lazy = false,
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        --nvim-notify for noice and notifications
        "rcarriga/nvim-notify",
        lazy = false,
        init = function()
          require("utils.functions").load_mappings("notify")
        end,
        opts = function()
          local notify = require("plugins.configs.nvim-notify")
          return notify.options
        end,
        config = function(_, opts)
          require("notify").setup(opts)
          require("plugins.configs.nvim-notify").setNotify()
          require("plugins.configs.nvim-notify").print_override()
        end,
      },
    },
    opts = function()
      return require("plugins.configs.noice")
    end,
    config = function(_, opts)
      require("noice").setup(opts)
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    --   build = 'make',
    opts = function()
      return require("plugins.configs.lualine")
    end,
    config = function(_, opts)
      require("lualine").setup(opts)
    end,
  },
  -- file managing , picker etc
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    init = function()
      require("utils.functions").load_mappings("nvimtree")
    end,
    opts = function()
      return require("plugins.configs.nvimtree")
    end,
    config = function(_, opts)
      require("nvim-tree").setup(opts)
      vim.g.nvimtree_side = opts.view.side
      vim.cmd([[hi NvimTreeWinSeparator guifg=#0f3a45]]) --it's for the line separating nvim-tree and the buffer
    end,
  },
  {
    "numToStr/Comment.nvim",
    -- keys = { "gc", "gb" },
    init = function()
      require("utils.functions").load_mappings("comment")
    end,
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    init = function()
      require("utils.functions").lazy_load("indent-blankline.nvim")
    end,
    opts = function()
      return require("plugins.configs.indent-blankline")
    end,
    config = function(_, opts)
      --TODO: Fix this mess
      -- temporary, pulling directly from svrana-neosolarized
      -- vim.cmd [[highlight IndentBlanklineChar guifg=#657b83 gui=nocombine]]
      -- vim.cmd [[highlight IndentBlankineSpaceChar guifg=#657b83 gui=nocombine]]
      -- vim.cmd [[highlight IndentBlanklineContextChar guifg=#586e75 gui=nocombine]]
      -- vim.cmd [[highlight IndentBlanklineContextStart guisp=#657b83 gui=nocombine]]
      --------
      vim.cmd([[highlight IndentBlanklineChar guifg=#0f3a45 gui=nocombine]])
      vim.cmd([[highlight IndentBlankineSpaceChar guifg=#0f3a45 gui=nocombine]])
      vim.cmd([[highlight IndentBlanklineContextChar guifg=#28535e gui=nocombine]])
      vim.cmd([[highlight IndentBlanklineContextStart guisp=#133e49 gui=nocombine]])
      require("utils.functions").load_mappings("blankline")
      require("indent_blankline").setup(opts) -- i have no idea why the original code differs like that
    end,
  },
  -- lsp stuff
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    opts = function()
      return require("plugins.configs.lsp.mason")
    end,
    config = function(_, opts)
      require("mason").setup(opts)
      -- custom nvchad cmd to install all mason binaries listed
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
      end, {})
      vim.g.mason_binaries_list = opts.ensure_installed
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        init = function()
          require("utils.functions").load_mappings("ufo")
        end,
        opts = function()
          require("plugins.configs.nvim-ufo")
        end,
        config = function(_, opts)
          require("ufo").setup(opts)
        end,
      },
      {
        "SmiteshP/nvim-navic",
      },
    },
    init = function()
      require("utils.functions").lazy_load("nvim-lspconfig")
    end,
    config = function()
      require("plugins.configs.lsp.lspconfig")
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    -- opts is currently unused
    -- opts = function()
    --   require("plugins.configs.lsp.null-ls")
    -- end,
    config = function(_, _)
      local null_ls = require("null-ls")
      null_ls.setup({
        -- we need to load null-ls first and then setup the sources and opts here,
        -- it's a little strange
        sources = {
          null_ls.builtins.formatting.stylua.with({
            extra_args = { "--indent-type", "Spaces", "--indent-width", "2" },
          }),
          null_ls.builtins.diagnostics.eslint_d,
          null_ls.builtins.formatting.prettier.with({
            extra_args = { "--single-quote", "false" },
          }),
          -- null_ls.builtins.formatting.terraform_fmt,
          -- null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.goimports,
          null_ls.builtins.formatting.gofumpt,
          -- null_ls.builtins.formatting.latexindent.with({
          --   extra_args = { "-g", "/dev/null" }, -- https://github.com/cmhughes/latexindent.pl/releases/tag/V3.9.3
          -- }),
          -- null_ls.builtins.code_actions.shellcheck,
          null_ls.builtins.code_actions.gitsigns,
          null_ls.builtins.formatting.shfmt,
          -- null_ls.builtins.diagnostics.ruff,
        },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("plugins.configs.luasnip").luasnip(opts)
        end,
      },
      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)
          -- setup cmp for autopairs
          local cmp_autopairs = require("nvim-autopairs.completion.cmp")
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      {
        "onsails/lspkind.nvim",
      },
      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "lukas-reineke/cmp-rg",
      },
    },
    opts = function()
      return require("plugins.configs.cmp")
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
    end,
  },

  -- make sure to load nvim-treesitter after indent-blankline otherwise things will break
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      require("utils.functions").lazy_load("nvim-treesitter")
    end,
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return require("plugins.configs.treesitter")
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    init = function()
      require("utils.functions").load_mappings("telescope")
    end,
    opts = function()
      return require("plugins.configs.telescope")
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },
  {
    "luukvbaal/statuscol.nvim",
    lazy = false,
    opts = function()
      return require("plugins.configs.statuscol")
    end,
    config = function(_, opts)
      require("statuscol").setup(opts)
      --     vim.cmd[[hi statusline guifg=NONE guibg=NONE gui=nocombine]]
    end,
  },
  -- Load whichkey after all other gui
  {
    "folke/which-key.nvim",
    keys = { "<leader>", '"', "'", "`", "c", "v" },
    init = function()
      require("utils.functions").load_mappings("whichkey")
    end,
    opts = function()
      return require("plugins.configs.whichkey")
    end,
    config = function(opts)
      require("which-key").setup(opts)
    end,
    lazy = false,
  },
}

local lazy_config = require("core.lazy") -- config for lazy.nvim

require("lazy").setup(default_plugins, lazy_config)
