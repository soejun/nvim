local options = {
  -- Define your formatters
  -- prefer toml and rc files
  -- log_level = vim.log.levels.INFO,
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "yapf" },
    javascript = { { "prettierd", "prettier" } },
    cs = { "csharpier" },
    sql = { "sqlfluff" },
    xml = { "xmlformat" }, -- No autocmd needed, it will detect *.*.proj .NET, MSBuild files accordingly
    ["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
    ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
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
    sqlfluff = { args = "format", "--dialect=ansi", "-" },
    xmlformat = {
      prepend_args = {
        --
        "--indent",
        "2",
        "--indent-char",
        " ",
        "--selfclose",
        "--preserve",
        "pre, literal, shortcut",
      },
    },
    ["markdown-toc"] = {
      condition = function(_, ctx)
        for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
          if line:find("<!%-%- toc %-%->") then
            return true
          end
        end
      end,
    },
    ["markdownlint-cli2"] = {
      condition = function(_, ctx)
        local diag = vim.tbl_filter(function(d)
          return d.source == "markdownlint"
        end, vim.diagnostic.get(ctx.buf))
        return #diag > 0
      end,
    },
  },
}

return options
