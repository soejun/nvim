---@type LazySpec
return {
  "folke/trouble.nvim",
  opts = {
    modes = {
      diagnostics = {
        -- Related to ruff and basedpyright showing excessive diagnostics when used together with  project config
        filter = function(items)
          return vim.tbl_filter(function(item)
            return item.severity ~= vim.diagnostic.severity.HINT
          end, items)
        end,
      },
    },
  },
}
