local options = {
  -- Define your formatters
  -- prefer toml and rc files
  -- log_level = vim.log.levels.INFO,
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "yapf" },
    javascript = { { "prettierd", "prettier" } },
    cs = { "csharpier" },
    xml = { "xmlformat" }, -- No autocmd needed, it will detect *.*.proj .NET, MSBuild files accordingly
  },
  -- Set up format-on-save
  -- format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
  -- Customize formatters
  formatters = {
    shfmt = {
      prepend_args = { "-i", "2" },
    },
    csharpier = {
      commands = "dotnet-csharpier",
      args = { "--write-stdout" },
    },
    xmlformat = {
      prepend_args = {
        --
        "--indent",
        "2",
        "--indent-char",
        " ",
        "--selfclose",
        "--preserve",
        "pre, literal",
      },
    },
  },
}

return options
