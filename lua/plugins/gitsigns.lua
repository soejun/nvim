-- VSCode/GitLens-style inline git blame.
-- gitsigns ships with LazyVim; this only layers the current-line blame on top
-- of LazyVim's defaults (signs + hunk keymaps via on_attach are left intact,
-- since opts tables are deep-merged).
return {
  "lewis6991/gitsigns.nvim",
  opts = {
    -- Unobtrusive blame annotation at the end of the current line, à la GitLens.
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- end of line; "right_align" pins it to the window edge
      delay = 300, -- ms after the cursor settles before the blame shows
      ignore_whitespace = false,
    },
    -- "<author>, <relative time> · <commit summary>"
    current_line_blame_formatter = "  <author>, <author_time:%R> · <summary>",
    current_line_blame_formatter_nc = "  <author>", -- shows "Not Committed Yet"
  },
  keys = {
    { "<leader>uB", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle Git Blame Line" },
  },
}
