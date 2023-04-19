require("core.options") -- all non plugin related (vim) options
require("utils.functions").load_mappings() --load mappings

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").lazy(lazypath)
end

vim.opt.rtp:prepend(lazypath)

require("plugins") --plugin management via lazy
require("core.autocmd") -- vim autocommands/autogroups
