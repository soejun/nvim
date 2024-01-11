local M = {}

function M.setup(_)
  require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
end

return M
