local M = {}


M = {
  options = {
    icons_enabled = true,
    theme = "auto",
    --    theme = 'solarized_dark',
    section_separators = { "|" },
    component_separators = {},
    disabled_filetypes = {},
  },
  sections = {
    lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
    lualine_b = {
      "branch",
      -- {
      --   "diff",
      --   colored = true,
      --   diff_color = {
      --     added = { fg = colors.green_diff },
      --     modified = { fg = colors.yellow_diff },
      --     removed = { fg = colors.red },
      --   },
      -- },
      { "diagnostics" },
    },
    lualine_c = {
      {
        "filename",
        file_status = true, -- displays file status (readonly status, modified status)
        path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path   ,
      },
    },
    lualine_x = { "encoding", "fileformat", "filetype" },
    --    lualine_x = {
    --      { 'diagnostics', sources = { "nvim_diagnostic" }, symbols = { error = ' ', warn = ' ', info = ' ',
    --        hint = ' ' } },
    --     'encoding',
    --    'filetype'
    --    },
    lualine_y = { "progress" },
    lualine_z = { { "location", separator = { right = "" }, left_padding = 2 } },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        "filename",
        file_status = true, -- displays file status (readonly status, modified status)
        path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
      },
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = { "location" },
  },
  tabline = {},
  extensions = {},
}
return M
