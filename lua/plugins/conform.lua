local use_isort_yapf = true
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
          "--stdin-filepath", "$FILENAME",
          "--semi=false",
          "--tab-width=2",
          "--single-quote",
          "--print-width=100",
          "--trailing-comma=none",
        },
      },
      -- isort = {
      --   command = "isort",
      --   args = { "-c", "-l", 120 },
      -- },
      -- yapf = {
      --   command = "yapf",
      --   args = { "--style={based_on_style: google, column_limit=120}", "-ire" },
      -- },
    },
    formtters_by_ft = {
      -- json = {
      --   "prettier",
      --   stop_after_first = true,
      -- },
      -- javascript = {
      --   "prettier",
      --   stop_after_first = true,
      -- },
      -- python = { "yapf", "isort", stop_after_first = true },
      sql = {
        "sqlfluff",
      },
    },
  },
}
