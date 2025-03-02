-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd({ "BufRead", "BufNewFile" }, {
  desc = "Ensure gitlab_ci_ls is properly activated for gitlab ci files",
  pattern = { "*.gitlab-ci*.{yml,yaml}", "kaniko-build.yml" },
  callback = function()
    vim.bo.filetype = "yaml.gitlab"
  end,
})

-- Comment out, was interfering with folds
-- local view_group = augroup("auto_view", { clear = true })
-- autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
--   desc = "Save view with mkview for real files",
--   group = view_group,
--   callback = function(args)
--     if vim.b[args.buf].view_activated then
--       vim.cmd.mkview({ mods = { emsg_silent = true } })
--     end
--   end,
-- })
--
-- autocmd("BufWinEnter", {
--   desc = "Try to load file view if available and enable view saving for real files",
--   group = view_group,
--   callback = function(args)
--     if not vim.b[args.buf].view_activated then
--       local filetype = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
--       local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
--       local ignore_filetypes = { "gitcommit", "gitrebase", "svg", "hgcommit" }
--       if buftype == "" and filetype and filetype ~= "" and not vim.tbl_contains(ignore_filetypes, filetype) then
--         vim.b[args.buf].view_activated = true
--         vim.cmd.loadview({ mods = { emsg_silent = true } })
--       end
--     end
--   end,
-- })

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = false
    vim.opt_local.spell = false
  end,
})
--       - Need to create cases for this, might be too complex a global config file is better.
-- TODO: Large code snippets in markdown files should be folded by default
