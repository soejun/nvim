return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
    },
    terminal = {
      win = {
        height = 0.27,
      },
      scroll = {
        animate = {
          duration = { step = 15, total = 150},
        },
      },
    },
  },
  -- URL for default bindings: https://www.lazyvim.org/extras/editor/snacks_picker
  -- stylua: ignore
  keys = {
    -- Note: Disable for No-Neck-Pain, use <leader>snt instead
    -- Disable keymap to pick snacks notifcations
    {"<leader>n", false}
      -- { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },

    -- TODO: Until we can make consistent disable our previous binding switch
    -- LazyVim docs imo switch the meaning of root dir and CWD, at least in a working sense,
    -- this is why we swap the =biindings here and set root = false
    -- { "<leader>/", LazyVim.pick("grep", { root = false }), desc = "Grep (cwd)" },
    -- { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
    -- find
    -- { "<leader>fF", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
    -- { "<leader>ff", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
    -- grep
    -- { "<leader>sG", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
    -- { "<leader>sg", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
    -- { "<leader>sW", LazyVim.pick("grep_word"), desc = "Visual selection or word (Root Dir)", mode = { "n", "x" } },
    -- { "<leader>sw", LazyVim.pick("grep_word", { root = false }), desc = "Visual selection or word (cwd)", mode = { "n", "x" } },
    -- search
  }
}
