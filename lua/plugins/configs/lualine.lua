local M = {}
local colors = {
  blue = "#268bd2",
  cyan = "#2aa198",
  black = "#073642",
  white = "#fdf6e3",
  red = "#dc322f",
  violet = "#6c71c4",
  grey = "#073642",
  base00 = "#657b83",
  base0 = "#586e75",
  base1 = "#93a1a1",
  green = "#719e07",
  yellow = "#b58900",
  orange = "#cb4b16",
}
local svrana_neosolarized_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.blue, gui = 'bold'},
    b = { fg = colors.black, bg = colors.base1},
    c = { fg = colors.base1, bg = colors.black},
  },

  insert = { a = { fg = colors.black, bg = colors.green} },
  visual = { a = { fg = colors.black, bg = colors.yellow} },
  replace = { a = { fg = colors.black, bg = colors.red } },

  inactive = {
    a = { fg = colors.white, bg = colors.black },
    b = { fg = colors.white, bg = colors.black },
    c = { fg = colors.black, bg = colors.black },
  },
}
M = {
  options = {
    icons_enabled = true,
    theme = svrana_neosolarized_theme,
--    theme = 'solarized_dark',
    section_separators = { left = '', right = '' },
    component_separators = { "|" },
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = { {'mode',  separator = { left = '' }, right_padding = 2} },
    lualine_b = { 'branch','diff',},
    lualine_c = { {
      'filename',
      file_status = true, -- displays file status (readonly status, modified status)
      path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
    } },
    lualine_x = {
      { 'diagnostics', sources = { "nvim_diagnostic" }, symbols = { error = ' ', warn = ' ', info = ' ',
        hint = ' ' } },
      'encoding',
      'filetype'
    },
    lualine_y = { 'progress' },
    lualine_z = {{ 'location',separator = { right = '' }, left_padding = 2}  }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { {
      'filename',
      file_status = true, -- displays file status (readonly status, modified status)
      path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
    } },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {'location'}
  },
  tabline = {},
  extensions = { }
}
return M
