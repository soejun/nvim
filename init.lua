
--require "core"
--require "utils"

-- we don't need, this is for nvchad custom chardrc`
-- local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

-- if custom_init_path then
--     dotfile(custom_init_path)
-- end

require("utils.functions").load_mappings() --load mappings

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    require("core.bootstrap").lazy(lazypath)
end
vim.opt.rtp:prepend(lazypath)

--init plugins
require "plugins"