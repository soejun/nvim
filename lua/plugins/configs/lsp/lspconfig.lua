
local utils = require "utils.functions"
local nvim_lsp = require("lspconfig")
local lsp_settings = require("plugins.configs.lsp.settings")

local M = {}

M.on_attach = function(client, bufnr)
  utils.load_mappings("lspconfig", { buffer = bufnr })
end


M.capabilities_arg = vim.lsp.protocol.make_client_capabilities()
M.capabilities = require("cmp_nvim_lsp").default_capabilities(M.capabilities_arg)

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
    settings = {
      Lua = lsp_settings.lua_ls
    },
  })
end
