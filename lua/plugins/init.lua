-- TODO: Organize into the following:
-- core essentials: plenary
-- ui related: tokyonight, nvim-tree, toggleterm
-- lsp functionality: mason, lsp_config
-- dap functionality: nvim-dap, nvim-dap-ui
-- utils organization as it relates to plugins, not core utils
-- database: it's been so long i forgot, whatever this is
local default_plugins = {
  { "nvim-lua/plenary.nvim", lazy = false, priority = 100 },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 90,
    config = function(_, _)
      require("plugins.themes.tokyonight")
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = false, -- stops invalid window id error
    config = function(_, _)
      require("nvim-web-devicons").setup({})
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    lazy = false,
    init = function()
      require("utils.functions").load_mappings("toggleterm")
    end,
    opts = function()
      return require("plugins.configs.toggleterm_opts")
    end,
    config = function(_, opts)
      require("toggleterm").setup(opts)
      require("utils.functions").toggle_term_mappings()
    end,
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
          return require("plugins.configs.nvim-notify").options
        end,
        config = function(_, opts)
          require("notify").setup(opts)
          require("plugins.configs.nvim-notify").setNotify()
          require("plugins.configs.nvim-notify").print_override()
        end,
      },
    },
    opts = function()
      return require("plugins.configs.noice_opts")
    end,
    config = function(_, opts)
      require("noice").setup(opts)
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    opts = function()
      return require("plugins.configs.lualine_opts")
    end,
    config = function(_, opts)
      require("lualine").setup(opts)
    end,
  },
  {
    -- UI Related
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
      -- TODO: I mean this is hacky as hell, we should redirect our attentions eventually to a unified theming effort
      -- Look to NvChad's themepicker for inspiration, we can figure out a list of highlights to configure to our own plugin needs
      vim.cmd([[highlight NvimTreeWinSeparator guifg=#3b4261]]) --it's for the line separating nvim-tree and the buffer
    end,
  },
  {
    -- Comments out blocks of code
    "numToStr/Comment.nvim",
    init = function()
      require("utils.functions").load_mappings("comment")
    end,
    config = function()
      require("Comment").setup()
    end,
  },
  {
    -- Shows lines as it relates to code indents (vertical lines)
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = function()
      return require("plugins.configs.indent-blankline")
    end,
    config = function(_, opts)
      require("ibl").setup(opts)
    end,
  },
  {
    -- LSP Functionality, good god organize this PLEASE PLEASE PLEASE
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    opts = function()
      return require("plugins.configs.lsp.mason")
    end,
    config = function(_, opts)
      require("mason").setup(opts)
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
      end, {})
      vim.g.mason_binaries_list = opts.ensure_installed
      local mr = require("mason-registry")
      local settings = require("core.settings")
      for _, tool in ipairs(settings.tools) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  },

  {
    -- LSP Functionality, why the hell is this separate from mason again?
    -- My god we just need a separate table for all this and just import it that way
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
      {
        "folke/neodev.nvim",
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
    -- RIP, deprecated, find different fork eventually
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function(_, _)
      local null_ls = require("null-ls")
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      null_ls.setup({
        debug = true,
        border = "rounded",
        sources = {
          null_ls.builtins.formatting.stylua.with({
            extra_args = { "--indent-type", "Spaces", "--indent-width", "2" },
          }),
          null_ls.builtins.diagnostics.eslint,
          null_ls.builtins.formatting.prettier.with({
            extra_args = { "--single-quote", "false" },
          }),
          -- python stuff --
          null_ls.builtins.formatting.black,
          null_ls.builtins.diagnostics.pylint,
          -- move over ruff, pylint is better
          -- null_ls.builtins.diagnostics.ruff,
          -- golang stuff --
          null_ls.builtins.formatting.goimports,
          null_ls.builtins.formatting.gofumpt,
          -- misc stuff --
          null_ls.builtins.code_actions.gitsigns,
          -- bash stuf --
          null_ls.builtins.code_actions.shellcheck,
          null_ls.builtins.diagnostics.shellcheck,
          null_ls.builtins.formatting.shfmt,
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                if AUTOFORMAT_ACTIVE then -- global var defined in functions.lua
                  vim.lsp.buf.format({ bufnr = bufnr })
                end
              end,
            })
          end
        end,
      })
    end,
  },
  {
    -- LSP Functionality, organize as well
    --
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("plugins.configs.luasnip_opts").luasnip(opts)
        end,
      },
      {
        "windwp/nvim-autopairs", -- autopairing of (){}[] etc
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts) -- setup cmp for autopairs
          local cmp_autopairs = require("nvim-autopairs.completion.cmp")
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },
      {
        "onsails/lspkind.nvim",
      }, -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        -- "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "lukas-reineke/cmp-rg",
      },
    },
    opts = function()
      return require("plugins.configs.cmp_opts")
    end,
    config = function(_, opts)
      -- require("saadparwaiz1/cmp_luasnip").setup()
      require("cmp").setup(opts)
    end,
  },

  {
    -- IMPORTANT: make sure to load nvim-treesitter after indent-blankline otherwise things will break
    -- Idk when the hell i wrote that above comment or how true that is now, fix later
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
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.tsx.filettpe_to_parsername = { "javascript", "typescript.tsx" }
    end,
  },

  { -- Again, why is this not with the autocomplete stuff??
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
  },
  {
    "windwp/nvim-ts-autotag",
    config = function(_, _)
      require("nvim-ts-autotag").setup()
    end,
  },

  {
    -- log highlighting
    "fei6409/log-highlight.nvim",
    config = function()
      require("log-highlight").setup({
        -- The following options support either a string or a table of strings.
        -- The file extensions.
        extension = "log",

        -- The file names or the full file paths.
        filename = {
          "messages",
        },

        -- The file path glob patterns, e.g. `.*%.lg`, `/var/log/.*`.
        -- Note: `%.` is to match a literal dot (`.`) in a pattern in Lua, but most
        -- of the time `.` and `%.` here make no observable difference.
        pattern = {
          "/var/log/.*",
          "messages%..*",
        },
      })
    end,
  },
  {
    -- Is this UI or utils? I think we need a separate UTILS thing
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
    -- What the hell is this again? I think UI related?
    "lewis6991/gitsigns.nvim",
    lazy = false,
    opts = function()
      return require("plugins.configs.gitsigns")
    end,
    config = function(_, opts)
      require("gitsigns").setup(opts)
    end,
  },
  {
    -- lmao pls, we need to figure out the config and organize for this
    "ray-x/go.nvim",
    dependencies = { "ray-x/guihua.lua" },
    event = "CmdLineEnter",
    ft = { "go", "gomod" },
    init = function()
      require("utils.functions").load_mappings("go")
    end,
    opts = function()
      return require("plugins.configs.lsp.ray-x-go")
    end,
    config = function(_, opts)
      require("go").setup(opts)
    end,
  },
  {
    -- Debugger functionality
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        keys = {
          {
            "<leader>du",
            function()
              require("dapui").toggle()
            end,
          },
          {
            "<leader>de",
            function()
              require("dapui").eval()
            end,
          },
        },
        opts = function()
          return require("plugins.configs.dap.ui")
        end,
        config = function(_, opts)
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup(opts)
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open({})
          end
          -- dap.listeners.before.event_terminated["dapui_config"] = function()
          --   dapui.close({})
          -- end
          -- dap.listeners.before.event_exited["dapui_config"] = function()
          --   dapui.close({})
          -- end
        end,
      },
      "theHamsta/nvim-dap-virtual-text",
      {
        "mfussenegger/nvim-dap-python",
        config = function(_, _)
          require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
        end,
      },
      {
        "leoluz/nvim-dap-go",
        config = function(_, _)
          require("dap-go").setup()
        end,
      },
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason.nvim",
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
          -- Makes a best effort to setup the various debuggers with
          -- reasonable debug configurations
          automatic_setup = true,
          -- You can provide additional configuration to the handlers,
          -- see mason-nvim-dap README for more information
          handlers = {},
          -- You'll need to check that you have the required things installed
          -- online, please don't ask me how to install them :)
          ensure_installed = {
            "python",
            "delve",
            -- Update this to ensure that you have the debuggers for the langs you want
          },
        },
      },
    },
    -- stylua: ignore start
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Breakpoint Condition", },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint", },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue", },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor", },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)", },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into", },
      { "<leader>dj", function() require("dap").down() end, desc = "Down", },
      { "<leader>dk", function() require("dap").up() end, desc = "Up", },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last", },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out", },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over", },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause", },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL", },
      { "<leader>ds", function() require("dap").session() end, desc = "Session", },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate", },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets", },
    },
    -- stylua: ignore end
    config = function(_, _)
      local icons = require("utils.lazyvim-icons")
      for name, sign in pairs(icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end
    end,
  },
  {
    -- Uhhh, what was this again? I know it deinitely broke something when i tried initially setting it up
    "luukvbaal/statuscol.nvim",
    lazy = false,
    opts = function()
      return require("plugins.configs.statuscol_opts")
    end,
    config = function(_, opts)
      require("statuscol").setup(opts)
    end,
  },
  {
    -- database gang, figure out later, this is low priority
    -- reason being is that god forbid we use nvim for db stuff
    "tpope/vim-dadbod",
    dependencies = {
      { "kristijanhusak/vim-dadbod-ui" },
      "kristijanhusak/vim-dadbod-completion",
    },
    opts = {
      db_completion = function()
        require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
      end,
    },
    config = function(_, opts)
      -- TODO: Dynamic save, propbably default create folder at wherever neovim is pulled up unless stated otherwise
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "sql",
        },
        command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "sql",
          "mysql",
          "plsql",
        },
        callback = function()
          vim.schedule(opts.db_completion)
        end,
      })
    end,
    -- TODO: Figure out load order for this so the keys here can literally not be here
    keys = {
      { "<leader>Dt", "<cmd>DBUIToggle<cr>", desc = "Toggle UI" },
      { "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "Find Buffer" },
      { "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>", desc = "Rename Buffer" },
      { "<leader>Dq", "<cmd>DBUILastQueryInfo<cr>", desc = "Last Query Info" },
    },
  },
  {
    -- TODO: Why the hell do we have this??
    "ray-x/web-tools.nvim",
    -- default port is 3000 for preview
    init = function()
      require("utils.functions").load_mappings("webtools")
    end,
    config = function(_, _)
      require("web-tools").setup({
        keymaps = {
          rename = nil, -- by default use same setup of lspconfig
          repeat_rename = ".", -- . to repeat
        },
        hurl = { -- hurl default
          show_headers = false, -- do not show http headers
          floating = false, -- use floating windows (need guihua.lua)
          formatters = { -- format the result by filetype
            json = { "jq" },
            html = { "prettier", "--parser", "html" },
          },
        },
      })
    end,
  },
  {
    -- belongs in utils
    "norcalli/nvim-colorizer.lua",
    config = function(_, _)
      require("colorizer").setup()
    end,
  },

  {
    -- Load whichkey after all other gui
    -- Again, why? In reference to load after everything else I know why we have this

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
require("lazy").setup(default_plugins)
