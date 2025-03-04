return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      sql_formatter = {
        -- I don't see us using anything other than postgresql right now
        -- So this is fine, eventually we'll use a .sql-formatter.json config file
        -- for different projects
        args = {
          "--language",
          "postgresql",
        },
      },
    },
    formatters_by_ft = {
      json = {
        "prettierd",
        stop_after_first = true,
      },
      javascript = {
        "prettierd",
        stop_after_first = true,
      },
      sql = {
        "sql_formatter",
      },
    },
  },
}
