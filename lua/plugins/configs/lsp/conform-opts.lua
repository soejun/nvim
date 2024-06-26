local options = {
    -- Define your formatters
    -- prefer toml and rc files
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "yapf" },
      javascript = { { "prettierd", "prettier" } },
    },
    -- Set up format-on-save
    -- format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
    -- Customize formatters
    formatters = {
      shfmt = {
        prepend_args = { "-i", "2" },
      },
    },
  }

return options
