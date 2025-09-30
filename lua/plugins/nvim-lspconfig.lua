return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      format_notify = true,
      inlay_hints = { enabled = false },
      servers = {
        awk_ls = {},
        bashls = {
          filetypes = { "sh", "zsh" },
        },
        -- Disabling this, for some reason these collid when using on hover for vue
        css_variables = {},
        cssls = {},
        cssmodules_ls = {},
        html = {
          filetypes = { "html", "templ", "htmldjango" },
        },
        -- See: https://www.reddit.com/r/neovim/comments/1603eif/comment/jxl4cvn/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
        -- pin jedi to 0.44.0, 0.45.0 has a bug
        jedi_language_server = {
          -- root_dir = function(fname)
          --   return lspconfig.util.root_pattern(".git", "package.json", "Makefile", "CMakeLists.txt")(fname)
          --     or vim.fn.getcwd()
          -- end,
        },
        jinja_lsp = {
          init_options = {
            templates = "./templates",
            backend = { "./src" },
            lang = "python",
          },
          filetypes = { "jinja", "html" },
        },
        gitlab_ci_ls = {},
        fsautocomplete = {},
        nginx_language_server = {},
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
  },
}
