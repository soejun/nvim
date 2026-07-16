-- Overrides only: LazyVim's lsp defaults (lazyvim.plugins.lsp.init) and the language
-- extras merge first; this table deep-merges last, so keys here win. Inspect the
-- final result with :LazyOpts nvim-lspconfig (defined in lua/config/options.lua),
-- and hover/gd the types below to jump to what actually gets merged.
---@type LazySpec
return {
  "neovim/nvim-lspconfig",
  init = function()
    -- ruff diagnostics carry no virtual text (signs/underline/pickers keep
    -- them). Diagnostic namespaces are created per (client, pull_id), so catch
    -- each by name as it first reports rather than predicting ids.
    local configured = {} ---@type table<integer, true>
    vim.api.nvim_create_autocmd("DiagnosticChanged", {
      group = vim.api.nvim_create_augroup("ruff_no_virtual_text", {}),
      callback = function()
        for name, ns in pairs(vim.api.nvim_get_namespaces()) do
          if not configured[ns] and name:find("^nvim%.lsp%.ruff%.") then
            configured[ns] = true
            vim.diagnostic.config({ virtual_text = false }, ns)
          end
        end
      end,
    })
  end,
  ---@type PluginLspOpts
  opts = {
    inlay_hints = { enabled = true },
    -- keys are vim.lsp.config server names; LazyVim adds mason/enabled/keys per server
    ---@type table<string, lazyvim.lsp.Config|boolean>
    servers = {
      -- servers["*"].keys is in lazy's opts_extend, so this appends to (not
      -- replaces) LazyVim's default LSP keymaps
      ["*"] = {
        ---@type LazyKeysLspSpec[]
        keys = {
          {
            "gR",
            function()
              Snacks.picker.lsp_references({ filter = { buf = true } })
            end,
            desc = "References (buffer)",
          },
        },
      },
      basedpyright = {
        enabled = true,
        settings = {
          basedpyright = {},
        },
      },
      bashls = {
        filetypes = { "sh", "zsh" },
      },
      -- NOTE: these css servers can produce colliding hovers in vue files
      css_variables = {},
      cssls = {},
      cssmodules_ls = {},
      fsautocomplete = {},
      gitlab_ci_ls = {},
      graphql = {},
      html = {
        init_options = { provideFormatter = true },
        filetypes = { "html", "templ", "htmldjango" },
      },
      metals = {
        ---@type LazyKeysLspSpec[]
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
          settings = {
            -- syntax errors belong to basedpyright (which has no switch to stop
            -- reporting them); silence ruff's duplicate `invalid-syntax` copies
            showSyntaxErrors = false,
          },
        },
        on_attach = function(client)
          -- hover belongs to basedpyright; virtual text is stripped in init above
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
