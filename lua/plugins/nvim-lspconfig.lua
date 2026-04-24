return {
  "neovim/nvim-lspconfig",
  opts = {
    format_notify = true,
    inlay_hints = { enabled = false },
    servers = {
      -- awk_ls = {},
      bashls = {
        filetypes = { "sh", "zsh" },
      },
      -- Disabling this, for some reason these collid when using on hover for vue
      css_variables = {},
      cssls = {},
      cssmodules_ls = {},
      html = {
        init_options = { provideFormatter = true },
        filetypes = { "html", "templ", "htmldjango" },
      },
      basedpyright = {
        enabled = true,
      },
      -- See: https://www.reddit.com/r/neovim/comments/1603eif/comment/jxl4cvn/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
      -- pin jedi to 0.44.0, 0.45.0 has a bug
      jedi_language_server = {
        enabled = false,
        -- root_dir = function(fname)
        --   return lspconfig.util.root_pattern(".git", "package.json", "Makefile", "CMakeLists.txt")(fname)
        --     or vim.fn.getcwd()
        -- end,
      },
      -- jinja_lsp = {
      --   init_options = {
      --     templates = "./carl/templates",
      --     backend = { "./carl" },
      --     lang = "python",
      --   },
      --   filetypes = { "jinja", "html", "python" },
      --   root_dir = require("lspconfig.util").root_pattern(
      --     "jinja-lsp.toml",
      --     "pyproject.toml",
      --     "Cargo.toml",
      --     ".git"
      --   ),
      -- },
      gitlab_ci_ls = {},
      graphql = {},
      fsautocomplete = {},
      metals = {
        keys = {
          {
            "<leader>me",
            function()
              require("telescope").extensions.metals.commands()
            end,
            desc = "Metals commands",
          },
          {
            "<leader>mc",
            function()
              require("metals").compile_cascade()
            end,
            desc = "Metals compile cascade",
          },
          {
            "<leader>mh",
            function()
              require("metals").hover_worksheet()
            end,
            desc = "Metals hover worksheet",
          },
        },
        init_options = {
          statusBarProvider = "off",
        },
        settings = {
          showImplicitArguments = true,
          excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
        },
      },
      nginx_language_server = {},
      ruff = {
        init_options = {
          settings = {},
        },
        on_attach = function(client, bufnr)
          -- client.server_capabilities.documentFormattingProvider = false
          -- client.server_capabilities.documentRangeFormattingProvider = false
          client.server_capabilities.hoverProvider = false
        end,
      },
      vimls = {},
      yamlls = {
        settings = {
          yaml = {
            editor = {
              tabSize = 2,
            },
          },
        },
      },
    },
  },
}
