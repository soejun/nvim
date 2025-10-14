local util = require("conform.util")
return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      sqlfluff = {
        command = "sqlfluff",
        args = { "format", "--dialect=postgres", "-" },
        stdin = true,
        cwd = function()
          return vim.fn.getcwd()
        end,
      },
      prettier = {
        args = {
          "--stdin-filepath",
          "$FILENAME",
          "--semi=false",
          "--tab-width=2",
          "--single-quote",
          "--print-width=100",
          "--trailing-comma=none",
        },
      },
      isort = {
        command = "isort",
        args = function(self, ctx)
          return {
            "--stdout",
            "--line-ending",
            util.buf_line_ending(ctx.buf),
            "--line-length",
            "120",
            "--filename",
            "$FILENAME",
            "-",
          }
        end,
        cwd = util.root_file({
          -- https://pycqa.github.io/isort/docs/configuration/config_files.html
          ".isort.cfg",
          "pyproject.toml",
          "setup.py",
          "setup.cfg",
          "tox.ini",
          ".editorconfig",
        }),
      },
      yapf = {
        command = "yapf",
        args = {
          "--style",
          "{based_on_style: google, column_limit: 120}",
        },
        range_args = function(self, ctx)
          return { "--quiet", "--lines", string.format("%d-%d", ctx.range.start[1], ctx.range["end"][1]) }
        end,
      },
    },
    formatters_by_ft = {
      python = { "isort", "yapf" },
      sql = {
        "sqlfluff",
      },
    },
  },
}
