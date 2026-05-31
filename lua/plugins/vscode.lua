return {
  "Mofiqul/vscode.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    -- Alternatively set style = "light"
    style = "dark",
    transparent = true, -- enable transparent background for snacks.nvim terminal compatibility
    italic_comments = true, -- enable italic comments
    italic_inlayhints = true, -- enable italic inlay type hints
    underline_links = true, -- underline `@markup.link.*` variants
    disable_nvimtree_bg = true, -- disable nvim-tree background color
    terminal_colors = true, -- apply theme colors to the integrated terminal
    color_overrides = {},
    group_overrides = {},
  },
}
