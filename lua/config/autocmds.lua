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


vim.api.nvim_create_autocmd("LspAttach", {
  once = true,
  callback = function()
    local method = "textDocument/inlayHint"
    local INLAY_HINT_MAX_LEN = 30
    local INLAY_HINT_ELLIPSIS = "…"
    local orig = vim.lsp.handlers[method]
    ---@param result lsp.InlayHint[]
    vim.lsp.handlers[method] = function(err, result, ctx, config)
      if result then
        for _, hint in ipairs(result) do
          local label = hint.label
          if type(label) == "string" then
            hint.label = #label > INLAY_HINT_MAX_LEN and (label:sub(1, INLAY_HINT_MAX_LEN) .. INLAY_HINT_ELLIPSIS)
              or label
          else
            local len, prev_len, parts = 0, 0, #label
            label = vim.tbl_filter(function(part)
              prev_len, len = len, len + #part.value
              return prev_len < INLAY_HINT_MAX_LEN
            end, label)
            if #label < parts then
              table.insert(label, { value = INLAY_HINT_ELLIPSIS })
            end
            hint.label = label
          end
        end
      end
      return orig(err, result, ctx, config)
    end
  end,
})
