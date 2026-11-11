-- MR review (diffs, threads, approvals) via gitlab.nvim; default keymaps live under `gl`.
return {
  "harrisoncramer/gitlab.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "dlyongemallo/diffview-plus.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    -- Token from the environment; instance URL from the origin remote, so no host is hardcoded.
    auth_provider = function()
      local remote = vim.fn.systemlist({ "git", "remote", "get-url", "origin" })[1] or ""
      local host = remote:match("^git@([^:]+):") or remote:match("^%a+://[^/@]*@?([^/:]+)")
      if not host then
        return nil, nil, "gitlab.nvim: could not read a host from the origin remote"
      end
      return vim.env.GITLAB_TOKEN, "https://" .. host, nil
    end,
  },
}
