return {
  "ellisonleao/gruvbox.nvim",
  opts = {
    terminal_colors = true, -- add neovim terminal colors
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
      strings = true,
      emphasis = true,
      comments = true,
      operators = false,
      folds = true,
    },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true, -- invert background for search, diffs, statuslines and errors
    contrast = "hard", -- can be "hard", "soft" or empty string
    palette_overrides = {},
    overrides = {
      -- snacks compatibility
      -- NonText = { fg = "#928374"} -- gray, snacks compatibility generic
      SnacksPickerDir = { link = "GruvboxGray" },
      SnacksDashboardDir = { link = "GruvboxGray" },
      SnacksPickerBufFlags = { link = "GruvboxGray" },
      SnacksPickerPathHidden = { link = "GruvboxGray" },
      SnacksPickerKeymapRhs = { link = "GruvboxGray" },
      SnacksPickerUnselected = { link = "GruvboxGray" },
      SnacksPickerTotals = { link = "GruvboxGray" },
      SnacksPickerPathIgnored = { link = "GruvboxGray" },
      SnacksWinKeySep = { link = "GruvBoxGray" },
      NonText = { link = "GruvBoxGray" }, -- This works better for visibility w/ snacks, at least until GruvBox gets updated
      -- https://github.com/ellisonleao/gruvbox.nvim/pull/372/commits/4be28bb8afc8986f838162109229c0774b3c2260
      -- BlinkCmpGhostText = { link = "GruvboxBg4" },
      -- BlinkCmpSource = { link = "GruvboxGray" },
    },
    dim_inactive = false,
    transparent_mode = true, -- enable true for snacks.nvim terminal compatibility
  },
}
