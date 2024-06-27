local M = {}

M = {
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = "",
    -- section_separators = { left = "", right = "" },
    -- component_separators = { left = "", right = "" },
    section_separators = { left = "" },
    disabled_filetypes = {},
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "searchcount" },
    lualine_x = { "filename", "filetype" },
    lualine_y = { { "location", separator = { left = "" } } },
    lualine_z = { "progress" },
  },
  inactive_sections = {},
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
}
return M
