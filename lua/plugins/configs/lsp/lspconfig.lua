
local utils = require "utils.functions"
local nvim_lsp = require("lspconfig")
local lsp_settings = require("plugins.configs.lsp.settings")

local M = {}

M.on_attach = function(client, bufnr)
  utils.load_mappings("lspconfig", { buffer = bufnr })
end


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

M.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)


local servers = {
  "lua_ls",
  "html",
  "cssls",
  "tsserver",
  "gopls",
  "bashls",
}

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup({
    on_attach = M.on_attach,
    capabilities = M.capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    settings = {
      Lua = lsp_settings.lua_ls
    },
  })
end
