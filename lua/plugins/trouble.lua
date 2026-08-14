---@type LazySpec
return {
  "folke/trouble.nvim",
  opts = {
    modes = {
      diagnostics = {
        -- Hide hints. The type servers report them again as linter errors:
        filter = { ["not"] = { severity = vim.diagnostic.severity.HINT } },
      },
    },
  },
}
