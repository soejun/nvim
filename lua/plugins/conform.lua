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
        command = "prettier",
        args = function(_, ctx)
          -- detect docker-compose files
          local filename = vim.api.nvim_buf_get_name(ctx.buf)
          local is_docker_compose = filename:match("docker[%w%-_.]*compose[%w%-_.]*%.ya?ml$")
            or filename:match("compose[%w%-_.]*%.ya?ml$")

          local args = {
            "--stdin-filepath",
            "$FILENAME",
            "--semi=false",
            "--tab-width=2",
            "--print-width=100",
            "--trailing-comma=none",
          }

          if is_docker_compose then
            -- Docker Compose files → use double quotes
            table.insert(args, "--single-quote=false")
          else
            -- all other files → use single quotes
            table.insert(args, "--single-quote=true")
          end

          return args
        end,
        stdin = true,
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
      sql = { "sqlfluff" },
      yaml = { "prettier" },
    },
  },
}
