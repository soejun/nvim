-- TODO: Add aerial.nvim
local default_plugins = {
  { "nvim-lua/plenary.nvim", lazy = false, priority = 100 },
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function(_, _)
      require("plugins.themes.onedark")
      vim.cmd([[colorscheme onedark]])
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    -- TODO: Fix load order to prevent window id error
    lazy = false, 
    config = function(_, _)
      require("nvim-web-devicons").setup({})
      vim.cmd([[hi WinBar guibg=transparent guifg=transparent]])
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
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    init = function()
      require("utils.functions").load_mappings("vim_tmux_navigator")
    end,
  },
  {
    "folke/noice.nvim",
    lazy = false,
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify", -- nvim-notify for noice and notifications
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
    "goolord/alpha-nvim",
    config = function()
      require("alpha").setup(require("alpha.themes.dashboard").config)
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
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = function()
      return require("plugins.configs.bufferline_opts")
    end,
    config = function(_, opts)
      require("bufferline").setup(opts)
    end,
  },
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
      for _, tool in ipairs(settings.mason_ensure_install_tools) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
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
        opts = {
          icons = {
            File = "󰈙 ",
            Module = " ",
            Namespace = "󰌗 ",
            Package = " ",
            Class = "󰌗 ",
            Method = "󰆧 ",
            Property = " ",
            Field = " ",
            Constructor = " ",
            Enum = "󰕘",
            Interface = "󰕘",
            Function = "󰊕 ",
            Variable = "󰆧 ",
            Constant = "󰏿 ",
            String = "󰀬 ",
            Number = "󰎠 ",
            Boolean = "◩ ",
            Array = "󰅪 ",
            Object = "󰅩 ",
            Key = "󰌋 ",
            Null = "󰟢 ",
            EnumMember = " ",
            Struct = "󰌗 ",
            Event = " ",
            Operator = "󰆕 ",
            TypeParameter = "󰊄 ",
          },
          lsp = {
            auto_attach = false,
            preference = nil,
          },
          highlight = true,
          separator = "  ",
          depth_limit = 0,
          depth_limit_indicator = "..",
          safe_output = true,
          lazy_update_context = false,
          click = false,
          format_text = function(text)
            return text
          end,
        },
        config = function(_, opts)
          -- onedark
          local colors = {
            black = "#3F4451",
            red = "#E06C75",
            green = "#98C379",
            yellow = "#D19A66",
            blue = "#61AFEF",
            magenta = "#C678DD",
            cyan = "#56B6C2",
            white = "#D7DAE0",
            bright_black = "#4F5666",
            bright_red = "#BE5046",
            bright_green = "#A5E075",
            bright_yellow = "#E5C07B",
            bright_blue = "#4DC4FF",
            bright_magenta = "#DE73FF",
            bright_cyan = "#4CD1E0",
            bright_white = "#E6E6E6",
          }
          require("nvim-navic").setup(opts)
          vim.api.nvim_set_hl(0, "NavicIconsFile", { default = true, bg = colors.black, fg = colors.blue })
          vim.api.nvim_set_hl(0, "NavicIconsModule", { default = true, bg = colors.black, fg = colors.cyan })
          vim.api.nvim_set_hl(0, "NavicIconsNamespace", { default = true, bg = colors.black, fg = colors.cyan })
          vim.api.nvim_set_hl(0, "NavicIconsPackage", { default = true, bg = colors.black, fg = colors.cyan })
          vim.api.nvim_set_hl(0, "NavicIconsClass", { default = true, bg = colors.black, fg = colors.yellow })
          vim.api.nvim_set_hl(0, "NavicIconsMethod", { default = true, bg = colors.black, fg = colors.blue })
          vim.api.nvim_set_hl(0, "NavicIconsProperty", { default = true, bg = colors.black, fg = colors.green })
          vim.api.nvim_set_hl(0, "NavicIconsField", { default = true, bg = colors.black, fg = colors.green })
          vim.api.nvim_set_hl(0, "NavicIconsConstructor", { default = true, bg = colors.black, fg = colors.magenta })
          vim.api.nvim_set_hl(0, "NavicIconsEnum", { default = true, bg = colors.black, fg = colors.yellow })
          vim.api.nvim_set_hl(0, "NavicIconsInterface", { default = true, bg = colors.black, fg = colors.yellow })
          vim.api.nvim_set_hl(0, "NavicIconsFunction", { default = true, bg = colors.black, fg = colors.blue })
          vim.api.nvim_set_hl(0, "NavicIconsVariable", { default = true, bg = colors.black, fg = colors.red })
          vim.api.nvim_set_hl(0, "NavicIconsConstant", { default = true, bg = colors.black, fg = colors.red })
          vim.api.nvim_set_hl(0, "NavicIconsString", { default = true, bg = colors.black, fg = colors.green })
          vim.api.nvim_set_hl(0, "NavicIconsNumber", { default = true, bg = colors.black, fg = colors.magenta })
          vim.api.nvim_set_hl(0, "NavicIconsBoolean", { default = true, bg = colors.black, fg = colors.magenta })
          vim.api.nvim_set_hl(0, "NavicIconsArray", { default = true, bg = colors.black, fg = colors.blue })
          vim.api.nvim_set_hl(0, "NavicIconsObject", { default = true, bg = colors.black, fg = colors.blue })
          vim.api.nvim_set_hl(0, "NavicIconsKey", { default = true, bg = colors.black, fg = colors.red })
          vim.api.nvim_set_hl(0, "NavicIconsNull", { default = true, bg = colors.black, fg = colors.yellow })
          vim.api.nvim_set_hl(0, "NavicIconsEnumMember", { default = true, bg = colors.black, fg = colors.green })
          vim.api.nvim_set_hl(0, "NavicIconsStruct", { default = true, bg = colors.black, fg = colors.yellow })
          vim.api.nvim_set_hl(0, "NavicIconsEvent", { default = true, bg = colors.black, fg = colors.yellow })
          vim.api.nvim_set_hl(0, "NavicIconsOperator", { default = true, bg = colors.black, fg = colors.cyan })
          vim.api.nvim_set_hl(0, "NavicIconsTypeParameter", { default = true, bg = colors.black, fg = colors.yellow })
          vim.api.nvim_set_hl(0, "NavicText", { default = true, bg = colors.black, fg = colors.white })
          vim.api.nvim_set_hl(0, "NavicSeparator", { default = true, bg = colors.black, fg = colors.white })
        end,
      },
      {
        "folke/neodev.nvim",
      },
      { "Hoffs/omnisharp-extended-lsp.nvim", lazy = true },
    },
    init = function()
      require("utils.functions").lazy_load("nvim-lspconfig")
    end,
    config = function()
      require("plugins.configs.lsp.lspconfig")
    end,
  },
  {
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
      },
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        -- "hrsh7th/cmp-nvim-lsp-signature-help", -- We disable because it conflicts with noice.nvim lsp signature help
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
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
    cmd = { "ConformInfo" },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      require("utils.functions").load_mappings("conform")
    end,
    -- TODO: Define mason install dependencies
    opts = function()
      return require("plugins.configs.lsp.conform-opts")
    end,
    config = function(_, opts)
      require("conform").setup(opts)
    end,
  },
  {
    -- configure linters per file, then setup autocmd to trigger linting
    -- this should follow the same paradigm as our lsp setup
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
      require("plugins.configs.lsp.nvim-lint")
    end,
  },
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
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.tsx.filettpe_to_parsername = { "javascript", "typescript.tsx" }
      parser_config.powershell = {
        install_info = {
          url = vim.fn.stdpath("config")
            .. (vim.g.is_windows and "\\tsparsers\\tree-sitter-powershell" or "/tsparsers/treesitter-powershell"),
          files = { "src/parser.c", "src/scanner.c" },
          branch = "main",
          generate_requires_npm = false,
          requires_generate_from_grammar = false,
        },
        filetype = "ps1",
      }
    end,
  },
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
  },
  {
    "windwp/nvim-ts-autotag",
    opts = function()
      return require("plugins.configs.nvim_ts_autotag_opts")
    end,
    config = function(_, opts)
      require("nvim-ts-autotag").setup(opts)
    end,
  },
  {
    "fei6409/log-highlight.nvim",
    opts = function()
      return require("plugins.configs.log_highlight_opts")
    end,
    config = function(_, opts)
      require("log-highlight").setup(opts)
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
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },

  {
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
    "mfussenegger/nvim-dap",
    init = function()
      require("utils.functions").load_mappings("dap")
    end,
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        init = function()
          require("utils.functions").load_mappings("dap_ui")
        end,
        opts = function()
          return require("plugins.configs.dap.ui")
        end,
        config = function(_, opts)
          local dap = require("dap")
          -- TODO: Fix
          if not dap.adapters["netcoredbg"] then
            require("dap").adapters["netcoredbg"] = {
              type = "executable",
              command = vim.fn.exepath("netcoredbg"),
              args = { "--interpreter=vscode" },
              options = { detached = false },
            }
          end
          for _, lang in ipairs({ "cs", "fsharp", "vb" }) do
            if not dap.configurations[lang] then
              dap.configurations[lang] = {
                {
                  type = "netcoredbg",
                  name = "Launch file",
                  request = "launch",
                  ---@diagnostic disable-next-line: redundant-parameter
                  program = function()
                    return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/", "file")
                  end,
                  cwd = "${workspaceFolder}",
                },
              }
            end
          end
          local dapui = require("dapui")
          dapui.setup(opts)
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open({})
          end
        end,
      },
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
      "theHamsta/nvim-dap-virtual-text",
    },
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
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    init = function()
      require("utils.functions").load_mappings("outline_nvim")
    end,
    opts = function()
      return require("plugins.configs.outline_opts")
    end,
    config = function(_, opts)
      require("outline").setup(opts)
    end,
  },

  {
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
    "tpope/vim-dadbod",
    dependencies = {
      {
        "kristijanhusak/vim-dadbod-ui",
        init = function()
          require("utils.functions").load_mappings("vim_dadbod")
        end,
      },
      "kristijanhusak/vim-dadbod-completion",
    },
    opts = {
      db_completion = function()
        require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
      end,
    },
    config = function(_, opts)
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
  },
  {
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
    "norcalli/nvim-colorizer.lua",
    config = function(_, _)
      require("colorizer").setup()
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      {
        "<leader>cp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
    config = function()
      vim.cmd([[do FileType]])
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    init = function()
      require("utils.functions").load_mappings("render_markdown")
    end,
    opts = {
      file_types = { "markdown", "norg", "rmd", "org" },
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      heading = {
        sign = false,
        icons = {},
      },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown", "norg", "rmd", "org" },
    config = function(_, opts)
      require("render-markdown").setup(opts)
    end,
  },
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
require("lazy").setup(default_plugins)
