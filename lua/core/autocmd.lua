local vim = vim
local api = vim.api

-- remove all trailing whitespace on save
local TrimWhiteSpaceGrp = api.nvim_create_augroup("TrimWhiteSpaceGrp", { clear = true })
api.nvim_create_autocmd("BufWritePre", {
  command = [[:%s/\s\+$//e]],
  group = TrimWhiteSpaceGrp,
})

-- Highlight on yank
api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Enable spell checking for certain file types
api.nvim_create_autocmd(
  { "BufRead", "BufNewFile" },
  -- { pattern = { "*.txt", "*.md", "*.tex" }, command = [[setlocal spell<cr> setlocal spelllang=en,de<cr>]] }
  {
    pattern = { "*.txt", "*.md", "*.tex" },
    callback = function()
      vim.opt.spell = true
      vim.opt.spelllang = "en"
    end,
  }
)

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

-- reload modules on save
local NvReload = api.nvim_create_augroup("NvReload", {})
api.nvim_create_autocmd("BufWritePost", {
  pattern = vim.tbl_map(vim.fs.normalize, vim.fn.glob(vim.fn.stdpath("config") .. "/lua/**/*.lua", true, true, true)),
  group = NvReload,
  callback = function(opts)
    local fp = vim.fn.fnamemodify(vim.fs.normalize(vim.api.nvim_buf_get_name(opts.buf)), ":r") --[[@as string]]
    local app_name = vim.env.NVIM_APPNAME and vim.env.NVIM_APPNAME or "nvim"
    local module = string.gsub(fp, "^.*/" .. app_name .. "/lua/", ""):gsub("/", ".")
    require("plenary.reload").reload_module(module)
    vim.cmd([[redraw!]])
  end,
})

local colors = require("utils.colors")
local hexcode = colors.temp_color
--TODO, Figure out better styling option
api.nvim_create_autocmd("VimEnter", {
  callback = function()
    api.nvim_command("hi WinSeparator guifg=" .. hexcode)
  end,
})
