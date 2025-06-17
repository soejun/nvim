return {
  "williamboman/mason.nvim",
  -- https://github.com/williamboman/mason.nvim/issues/1508#issuecomment-1745259185
  -- To downgrade a lsp, you'd have to go into ~/.local/share/nvim/mason/registries/github/mason-org/mason-registry
  -- and  manually change the  target
  opts = {
    ensure_installed = {
      "stylua",
      "shfmt",
      "prettier",
      -- "isort",
      -- "yapf"
    },
  },
}
