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
    lualine_c = { { "filename", path = 1 }, "filetype" },
    lualine_x = {},
    lualine_y = { { "searchcount" } },
    lualine_z = { { "location", separator = { left = "" }, padding = { left = 0, right = 1 } } },
  },
  inactive_sections = {},
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
}
return M
