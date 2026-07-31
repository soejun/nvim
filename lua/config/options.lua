-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.autoformat = false
vim.g.snacks_animate = true
vim.g.lazyvim_python_lsp = "basedpyright"
vim.opt.wrap = false

vim.api.nvim_create_user_command("LspInfo", ":checkhealth vim.lsp", { desc = "Alias to `:checkhealth vim.lsp`" })

-- Show the opts lazy.nvim hands a plugin after LazyVim defaults, extras and
-- lua/plugins/* are deep-merged, e.g. :LazyOpts nvim-lspconfig
vim.api.nvim_create_user_command("LazyOpts", function(cmd)
  local plugin = require("lazy.core.config").plugins[cmd.args]
  if not plugin then
    return vim.notify("No plugin named `" .. cmd.args .. "`", vim.log.levels.ERROR)
  end
  Snacks.debug.inspect(require("lazy.core.plugin").values(plugin, "opts", false))
end, {
  nargs = 1,
  desc = "Inspect a plugin's merged opts",
  complete = function(prefix)
    local names = vim.tbl_filter(function(name)
      return name:find(prefix, 1, true) == 1
    end, vim.tbl_keys(require("lazy.core.config").plugins))
    table.sort(names)
    return names
  end,
})
