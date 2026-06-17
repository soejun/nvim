return {
  "folke/tokyonight.nvim",
  enabled = true,
  lazy = false,
  opts = {
    transparent = false,
    style = "moon",
    terminal_colors = true,
    styles = {
      -- sidebars = "transparent",
      -- floats = "transparent",
    },
    -- Inlay hints, line numbers and unused-import ("unnecessary") diagnostics
    -- should stay dimmer than normal text *and* than the comment colour
    -- (#636da6) so they read as de-emphasised and don't blend into comments.
    -- Tokyo Night moon defaults are too dark to read comfortably:
    --   LspInlayHint           fg = #545c7e (dark3)
    --   DiagnosticUnnecessary  fg = #444a73 (terminal_black)
    --   LineNr/Above/Below     fg = #3b4261 (fg_gutter)
    -- Tuned: #737aa2 (too bright) -> #636da6 (=comment) -> #5a638e
    -- Inlay hints sit one notch brighter (#5e6896) for readability.
    -- CursorLineNr (current line) is left as the default bold orange.
    on_highlights = function(highlights, colors)
      highlights.LspInlayHint.fg = "#5e6896" -- a touch brighter; bg stays #24283c
      highlights.DiagnosticUnnecessary.fg = "#5a638e"
      highlights.LineNr.fg = "#5a638e"
      highlights.LineNrAbove.fg = "#5a638e"
      highlights.LineNrBelow.fg = "#5a638e"
    end,
  },
}
