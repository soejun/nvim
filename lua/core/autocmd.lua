vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Disable New Line Comment",
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*pylintrc", "*.service", "*.mount" },
  callback = function()
    vim.api.nvim_command("set filetype=ini")
  end,
  desc = "set ini-like files to filetype ini",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  desc = "Set ini-like files to filetype ini",
  pattern = { "*.conf", "lfrc*" },
  callback = function()
    vim.api.nvim_command("set filetype=bash")
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  desc = "Ensure docker-compose-language-service is properly activated for docker-compose files",
  pattern = {
    "docker-*.{yml,yaml}",
    "compose.{,yml,yaml}",
  },
  callback = function()
    vim.api.nvim_command("set filetype=yaml.docker-compose")
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  desc = "Ensure gitlab_ci_ls is properly activated for gitlab ci files",
  pattern = { "*.gitlab-ci*.{yml,yaml}", "kaniko-build.yml" },
  callback = function()
    vim.bo.filetype = "yaml.gitlab"
  end,
})

--
vim.api.nvim_create_autocmd("FileType", {
  desc = "Windows to close with q",
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

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "go to last loc when opening a buffer",
})
