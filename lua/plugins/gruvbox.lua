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
      SnacksPickerDir = { link = "GruvboxGray" },
      SnacksDashboardDir = { link = "GruvboxGray" },
      SnacksPickerBufFlags = { link = "GruvboxGray" },
      SnacksPickerPathHidden = { link = "GruvboxGray" },
      SnacksPickerKeymapRhs = { link = "GruvboxGray" },
      SnacksPickerUnselected = { link = "GruvboxGray" },
      SnacksPickerTotals = { link = "GruvboxGray" },
      SnacksPickerPathIgnored = { link = "GruvboxGray" },
      SnacksWinKeySep = { link = "GruvboxGray" },
      NonText = { link = "GruvboxGray" }, -- This works better for visibility w/ snacks, at least until GruvBox gets updated
      BlinkCmpMenu = { bg = "#3C3836" },
      FloatBorder = { link = "GruvboxFg4" },
    },
    dim_inactive = false,
    transparent_mode = true, -- enable true for snacks.nvim terminal compatibility
  },
}
