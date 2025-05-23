return {
  "folke/tokyonight.nvim",
  enabled = false,
  opts = {
    transparent = true,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
    on_highlights = function(highlight, color)
      highlight.WinSeparator = { fg = "#636da6" }
    end,
  },
}
