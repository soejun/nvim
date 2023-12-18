--nvim-notify options
local notify = require("notify")
local M = {}
--Overriding vim.notify with notify if notify exists

M.setNotify = function()
  vim.notify = notify
end

M.print_override = function(...)
  local print_safe_args = {}
  local _ = { ... }
  for i = 1, #_ do
    table.insert(print_safe_args, tostring(_[i]))
    notify(table.concat(print_safe_args, " "), "info")
  end
end

M.options = {
  on_open = function(win)
    local config = vim.api.nvim_win_get_config(win)
    config.border = "single"
    vim.api.nvim_win_set_config(win, config)
  end,
  background_colour = "#24283b",
  fps = 60,
  icons = {
    DEBUG = "",
    ERROR = "",
    INFO = "",
    TRACE = "✎",
    WARN = "",
  },
  level = 2,
  minimum_width = 50,
  render = "minimal",
  stages = "fade_in_slide_out",
  timeout = 5000,
  top_down = true,
}

return M
