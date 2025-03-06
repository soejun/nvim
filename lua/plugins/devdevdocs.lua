return {
  "maskudo/devdocs.nvim",
  lazy = false,
  dependencies = {
    "folke/snacks.nvim",
  },
  opts = {
    -- TODO: Organize
    ensure_installed = {
      "bash",
      "go",
      "html",
      "dom",
      "http",
      "css",
      "javascript",
      -- "rust",
      -- some docs such as lua require version number along with the language name
      -- check `DevDocs install` to view the actual names of the docs
      "lua~5.1",
      -- "openjdk~21"
      "nginx",
      "postgresql~16",
      "jquery",
      "python~3.10",
      "flask~2.0",
      "jinja~3.0",
      "bootstrap~3",
      "jq",
      "docker",
      "duckdb",
      "vue~3"
    },
  },
  -- stylua: ignore
  keys = {
    { "<leader>ho", mode = "n", "<cmd>DevDocs get<cr>", desc = "Get Devdocs", },
    { "<leader>hi", mode = "n", "<cmd>DevDocs install<cr>", desc = "Install Devdocs", },
    { "<leader>hv",
      mode = "n",
      function()
        local devdocs = require("devdocs")
        local installedDocs = devdocs.GetInstalledDocs()
        vim.ui.select(installedDocs, {}, function(selected)
          if not selected then
            return
          end
          local docDir = devdocs.GetDocDir(selected)
          -- prettify the filename as you wish
          Snacks.picker.files({ cwd = docDir })
        end)
      end,
      desc = "View Devdocs",
    },
  },
  config = function (_, opts)
  require("devdocs").setup(opts)
  end,
}
