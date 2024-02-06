local M = {}
-- The debugger will automatically pick-up another virtual environment if it is activated before neovim is started.

function M.setup(_)
  -- require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
  require("dap-python").resolve_python = function()
    return "/home/wchan/.pyenv/shims/python3"
  end
end

return M
