local vim = vim
local api = vim.api

-- TODO: Add binding to toggle autoformat, temporarily use manual binding instead
-- remove all trailing whitespace on save
-- local TrimWhiteSpaceGrp = api.nvim_create_augroup("TrimWhiteSpaceGrp", { clear = true })
-- api.nvim_create_autocmd("BufWritePre", {
--   command = [[:%s/\s\+$//e]],
--   group = TrimWhiteSpaceGrp,
-- })

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Disable New Line Comment",
})

-- Highlight on yank
api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- set various configuration files to .ini file types where applicable
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*pylintrc", "*.service", "*.mount" },
  callback = function()
    vim.api.nvim_command("set filetype=ini")
  end,
  desc = "set ini-like files to filetype ini",
})

api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.conf", "lfrc*"},
  callback = function()
    vim.api.nvim_command("set filetype=bash")
  end,
  desc = "set ini-like files to filetype ini",
})


-- windows to close with "q"
api.nvim_create_autocmd("FileType", {
  pattern = {
    "checkhealth",
    "dap-float",
    "fugitive",
    "help",
    "man",
    "notify",
    "null-ls-info",
    "qf",
    "PlenaryTestPopup",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "go to last loc when opening a buffer",
})

-- cursor line stuff
local cursorGrp = api.nvim_create_augroup("CursorLine", { clear = true })
api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  pattern = "*",
  command = "set cursorline",
  group = cursorGrp,
  desc = "show cursor line only in active window",
})
api.nvim_create_autocmd(
  { "InsertEnter", "WinLeave" },
  { pattern = "*", command = "set nocursorline", group = cursorGrp }
)

-- reload modules on save

local NvReload = api.nvim_create_augroup("NvReload", {})
api.nvim_create_autocmd("BufWritePost", {
  pattern = vim.tbl_map(function(path)
    return vim.fs.normalize(path):gsub("\\", "/")
  end, vim.fn.glob(vim.fn.stdpath("config") .. "/lua/**/*.lua", true, true, true)),
  group = NvReload,
  callback = function(opts)
    local fp = vim.fn.fnamemodify(vim.fs.normalize(vim.api.nvim_buf_get_name(opts.buf)), ":r"):gsub("\\", "/") --[[ @as string ]]
    local app_name = vim.env.NVIM_APPNAME and vim.env.NVIM_APPNAME or "nvim"
    local module = string.gsub(fp, "^.*/" .. app_name .. "/lua/", ""):gsub("/", ".")
    require("plenary.reload").reload_module(module)
    vim.cmd([[redraw!]])
  end,
})

local colors = require("utils.colors")
-- local hexcode = colors.temp_color2
local hexcode = "#3b4261"
--TODO, Figure out better styling option
api.nvim_create_autocmd("VimEnter", {
  callback = function()
    api.nvim_command("hi WinSeparator guifg=" .. hexcode)
  end,
})

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require("go.format").goimport()
  end,
  group = format_sync_grp,
})

-- TODO: Quit on man page
