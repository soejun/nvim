-- LazyVim core already registers lazydev with word-gated libraries for LazyVim,
-- snacks.nvim, lazy.nvim, luv and lspconfig settings (see lazyvim.plugins.coding).
-- opts is a function so this APPENDS: a plain table would index-merge over that list.
return {
  "folke/lazydev.nvim",
  opts = function(_, opts)
    -- load lazy.nvim types for annotations like ---@type LazySpec / LazyKeysSpec
    -- in files that never mention the core trigger word "LazyVim"
    table.insert(opts.library, { path = "lazy.nvim", words = { "Lazy%u" } })
  end,
}
