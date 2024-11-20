require("core.options") -- all non plugin related (vim) options
require("utils.functions").load_mappings()

-- check if windows
is_windows = vim.loop.os_uname().sysname == "Windows_NT"
if is_windows then
  -- Set the shell to pwsh (PowerShell Core) if available, otherwise fallback to powershell
  vim.opt.shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"

  vim.opt.shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"

  -- Set the shell redirection flag for PowerShell
  vim.opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"

  -- Set the shell pipe flag for PowerShell
  vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"

  -- Set the shell quote and shell xquote to empty strings
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
end

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. (is_windows and "\\lazy\\lazy.nvim" or "/lazy/lazy.nvim")
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").lazy(lazypath)
end

vim.opt.rtp:prepend({ lazypath })

require("plugins") --plugin management via lazy
require("core.autocmd")
if is_windows == false then
vim.cmd([[  set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175]])
end
AUTOFORMAT_ACTIVE = false
