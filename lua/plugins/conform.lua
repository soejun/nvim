local util = require("conform.util")

-- prettier resolves its own config zoo (.prettierrc*, prettier.config.*,
-- package.json "prettier"), so ask it instead of tracking filenames.
-- Cached per directory; picking up a newly added config needs a restart.
local prettier_config_found = {}
local function has_prettier_config(dirname, filename)
  if prettier_config_found[dirname] == nil then
    vim.fn.system({ "prettier", "--find-config-path", filename })
    prettier_config_found[dirname] = vim.v.shell_error == 0
  end
  return prettier_config_found[dirname]
end

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
        -- command comes from conform's builtin: repo node_modules/.bin/prettier, else mason's
        args = function(_, ctx)
          -- a repo prettier config wins; the flags below only apply without one
          if has_prettier_config(ctx.dirname, ctx.filename) then
            return { "--stdin-filepath", "$FILENAME" }
          end

          -- detect docker-compose files
          local is_docker_compose = ctx.filename:match("docker[%w%-_.]*compose[%w%-_.]*%.ya?ml$")
            or ctx.filename:match("compose[%w%-_.]*%.ya?ml$")

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
      -- python = { "ruff" },
      -- python = { ruff, "isort", "yapf" },
      sql = { "sqlfluff" },
      yaml = { "prettier" },
    },
  },
}
