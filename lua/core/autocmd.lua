local vim = vim
local api = vim.api

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Disable New Line Comment",
})

api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*pylintrc", "*.service", "*.mount" },
  callback = function()
    vim.api.nvim_command("set filetype=ini")
  end,
  desc = "set ini-like files to filetype ini",
})

-- sets .conf and lfrc to use bash syntax highlighting
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.conf", "lfrc*" },
  callback = function()
    vim.api.nvim_command("set filetype=bash")
  end,
  desc = "set ini-like files to filetype ini",
})

-- docker_compose_language_service
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = {
    "docker-*.{yml,yaml}",
    "compose.{,yml,yaml}",
  },
  callback = function()
    vim.api.nvim_command("set filetype=yaml.docker-compose")
  end,
  desc = "ensure docker-compose-language-service is properly activated for docker-compose files",
})

-- gitlab_ci_ls
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.gitlab-ci*.{yml,yaml}", "kaniko-build.yml" },
  callback = function()
    vim.bo.filetype = "yaml.gitlab"
  end,
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
