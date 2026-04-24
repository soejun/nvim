-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd({ "BufRead", "BufNewFile" }, {
  desc = "Ensure gitlab_ci_ls is properly activated for gitlab ci files",
  pattern = { "*.gitlab-ci*.{yml,yaml}", "kaniko-build.yml", "step.{yml,yaml}", "templates/*.yml" },
  callback = function()
    vim.bo.filetype = "yaml.gitlab"
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = false
    vim.opt_local.spell = false
  end,
})

-- When working with existing html files of tabSpace 4
autocmd("FileType", {
  desc = "Use 4-space indentation for HTML files",
  pattern = { "html", "templ", "htmldjango" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
  end,
})

autocmd({ "BufRead", "BufNewFile" }, {
  desc = "Set file type to xml for .NET related files",
  pattern = { "*.{wxs,wxl,wxi,wixproj,sln,csproj}"},
  callback = function()
    vim.bo.filetype = "xml"
  end,
})
