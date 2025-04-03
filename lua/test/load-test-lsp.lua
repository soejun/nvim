-- testing our sandbox lsp
--
local client = vim.lsp.start_client({
  name = "sandboxlsp",
  cmd = {
    "/Users/soejun/Workspace/sandbox-lsp/sandboxlsp",
    -- on_attach may not be necesary, its just for keybindings
    -- eh lets just see wht happens
    -- on_attach = require("lazyvim.plugins.lsp.keymaps"),
  },
})

if not client then
  vim.notify("hey you didnt do client thing good")
  return
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- pass current buffer and client we defined earlier
    vim.lsp.buf_attach_client(0, client)
  end
})
