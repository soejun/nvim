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
    },
    formtters_by_ft = {
      json = {
        "prettierd",
        stop_after_first = true,
      },
      javascript = {
        "prettierd",
        stop_after_first = true,
      },
      sql = {
        "sqlfluff",
      },
    },
  },
}
