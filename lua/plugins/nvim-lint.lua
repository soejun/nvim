local nvim_config = vim.fn.stdpath('config')
return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters = {
      ["markdownlint-cli2"] = {
        args = { "--config", nvim_config .. "/.markdownlint-cli2.yaml", "--" },
      },
    },
  },
}


