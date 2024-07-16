local M = {}

M = {
  options = {
    icons_enabled = true,
    theme = "auto",
    -- component_separators = "",
    -- section_separators = { left = "", right = "" },
    component_separators = { left = "󰇙", right = "" },
    -- component_separators = { left = "|", right = "" },

    -- triangles: ,,,
    -- section_separators = { left = "",right = '' },
    section_separators = { left = "", right = "" },

    disabled_filetypes = {},
  },
  sections = {
    lualine_a = {
      {
        "filetype",
        colored = false,
        icon_only = true,
        icon = { align = "left" },
        padding = { left = 1, right = 0 },
        separator = "",
      },
      { "mode", separator = "" },
    },
    lualine_b = {
      { "branch" },
      {
        "diff",
        symbols = {
          added = " ",
          modified = " ",
          removed = " ",
        },
      },
    },
    lualine_c = {
      { "filename", path = 1, padding = { left = 1, right = 1 } },
    },
    lualine_x = {
      {
        "diagnostics",
        symbols = {

          error = " ",
          warn = " ",
          hint = " ",
          info = " ",
        },
      },
    },
    lualine_y = {
      { "fileformat" },
      { "encoding" },
      { "filesize", separator = "󰇙" },
      { "location", padding = { left = 1, right = 1 } },
    },
    lualine_z = { { "progress", separator = { left = "" } } },
  },
  inactive_sections = {},
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
}
return M
