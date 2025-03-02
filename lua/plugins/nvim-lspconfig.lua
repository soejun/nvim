local lspconfig = require("lspconfig")

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      format_notify = true,
      inlay_hints = { enabled = false },
      servers = {
        bashls = {
          filetypes = { "sh", "zsh" },
        },
        -- Disabling this, for some reason these collid when using on hover for vue
        -- css_variables = {},
        -- cssls= {},
        -- cssmodules_ls = {},
        html = {
          filetypes = { "html", "templ", "htmldjango" },
        },
        jedi_language_server = {},
        gitlab_ci_ls = {},
        nginx_language_server = {},
        volar = {
          init_options = {
            vue = {
              -- Oh, yeah they definitely conflict if this is set to false
              hybridMode = true,
            },
          },
        },
      },
    },
  },
}
