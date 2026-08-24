-- Overrides only: LazyVim's lsp defaults (lazyvim.plugins.lsp.init) and the language
-- extras merge first; this table deep-merges last, so keys here win. Inspect the
-- final result with :LazyOpts nvim-lspconfig (defined in lua/config/options.lua),
-- and hover/gd the types below to jump to what actually gets merged.
---@type LazySpec
return {
  "neovim/nvim-lspconfig",
  init = function()
    local overrides = {
      ["^nvim%.lsp%.ruff%."] = function()
        return { virtual_text = false }
      end,
      ["^nvim%.lsp%.vtsls%."] = function()
        -- keep the global virtual text styling, add a severity floor
        local vt = vim.diagnostic.config().virtual_text
        vt = type(vt) == "table" and vim.deepcopy(vt) or {}
        vt.severity = { min = vim.diagnostic.severity.INFO }
        return { virtual_text = vt }
      end,
    }
    -- every namespace already checked, matching or not. A namespace name is
    -- fixed at creation, so one that misses every pattern never matches later;
    -- caching only the hits re-tested every miss on each DiagnosticChanged.
    local seen = {} ---@type table<integer, true>
    vim.api.nvim_create_autocmd("DiagnosticChanged", {
      group = vim.api.nvim_create_augroup("lsp_ns_diagnostic_overrides", {}),
      callback = function()
        for name, ns in pairs(vim.api.nvim_get_namespaces()) do
          if not seen[ns] then
            seen[ns] = true
            for pat, make_config in pairs(overrides) do
              if name:find(pat) then
                vim.diagnostic.config(make_config(), ns)
                break
              end
            end
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
        -- Typing in a big TS/Vue project sends a didChange per keystroke group
        -- (default debounce 150ms) and every server re-checks each time. Batch
        -- them into one sync per second instead.
        -- https://www.reddit.com/r/neovim/comments/1guifug/lsp_extreme_lag/
        -- NOTE: change tracking groups clients by sync kind and uses the
        -- smallest debounce in the group, so this only takes effect when every
        -- server attached to the buffer sets it.
        -- flags = { debounce_text_changes = 1000 },
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
        -- enabled = true,
        -- settings = {
        --   basedpyright = {},
        -- },
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
      graphql = {
        filetypes = { "graphql", "typescriptreact", "javascriptreact", "typescript", "javascript", "vue" },
      },
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
      vtsls = {
        -- NOTE: do not set flags.allow_incremental_sync = false here. Full
        -- document sync makes vtsls send tsserver a whole-file range that ends
        -- one line past the file, and tsserver aborts the process with
        -- "Debug Failure. Bad line number". vue_ls then reports that it cannot
        -- find vtsls, because the process is gone.
        settings = {
          vtsls = {
            experimental = {
              maxInlayHintLength = 60,
            },
          },
          typescript = {
            inlayHints = {
              variableTypes = { enabled = false },
            },
          },
        },
      },
    },
  },
}
