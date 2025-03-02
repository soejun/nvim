return {
  "kawre/leetcode.nvim",
  -- build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
  -- to login, use firefox
  -- leetcode.com -> login -> inspect -> network -> fitler-url: graphql -> Headers -> Request Hewaders -> Cooking (starts with csrftoken)
  dependencies = {
    -- "nvim-telescope/telescope.nvim",
    "ibhagwan/fzf-lua",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    lang = "python",
  },
}
