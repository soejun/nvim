return {
  "folke/tokyonight.nvim",
  enabled = true,
  lazy = false,
  opts = {
    transparent = false,
    style = "moon",
    terminal_colors = true,
    -- styles = {
    --   sidebars = "transparent",
    --   floats = "transparent",
    -- },
    on_highlights = function(highlight, color)
      highlight.WinSeparator = { fg = "#636da6" }
    end,
  },
}
