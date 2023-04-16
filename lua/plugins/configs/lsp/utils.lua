local M = {}
local utils = require("utils.functions")

AUTOFORMAT_ACTIVE = true
-- toggle null-ls's autoformatting
M.toggle_autoformat = function()
  AUTOFORMAT_ACTIVE = not AUTOFORMAT_ACTIVE
  utils.notify(
    string.format("Autoformatting %s", AUTOFORMAT_ACTIVE and "on" or "off"),
    vim.log.levels.INFO,
    "lsp.utils"
  )
end

M.format = function ()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  local have_nls = #require("null-ls.sources").get_available(ft, "NULL_LS_FORMMATING") > 0

  vim.lsp.buf.format(vim.tbl_deep_extend("force",{
    bufnr = buf,
    filter = function(client)
    if have_nls then
      return client.name == "null-ls"
      end
    return client.name ~= "null-ls"
    end,
  }))
end

return M
