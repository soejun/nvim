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
        -- example path
        -- /home/wchan/Workspace/Internal-Tools/recruiting/recruiting-portal/portal/portal/templates/default/challenge.html
        -- jinja_lsp = {
        --   default_config = {
        --     name = "jinj-lsp",
        --
        --   }
        -- },
        gitlab_ci_ls = {},
        nginx_language_server = {},
        tsserver = {
          enabled = false,
        },
        ts_ls = {
          enabled = false,
        },
        volar = {
          init_options = {
            vue = {
              -- Oh, yeah they definitely conflict if this is set to false
              hybridMode = true,
            },
          },
        },
      },
      vtsls = {
        -- explicitly add default filetypes, so that we can extend
        -- them in related extras
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
        settings = {
          complete_function_calls = true,
          vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
            experimental = {
              maxInlayHintLength = 30,
              completion = {
                enableServerSideFuzzyMatch = true,
              },
            },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = {
              completeFunctionCalls = true,
            },
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = false },
            },
            tsserver = {
              maxTsServerMemory = 8192
            }
          },
        },
      },
    },
  },
}
