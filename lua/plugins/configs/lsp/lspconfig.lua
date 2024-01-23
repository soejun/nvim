local utils = require("utils.functions")
local nvim_lsp = require("lspconfig")
local settings = require("core.settings")
local lsp_settings = require("plugins.configs.lsp.settings")
local navic = require("nvim-navic")

local M = {}

-------------------- on_attach logic ----------------------

local lsp_formatting = function(bufnr)
  vim.lsp.buf.format({
    filter = function(client)
      -- apply whatever logic you want (in this example, we'll only use null-ls)
      return client.name == "null-ls"
    end,
    bufnr = bufnr,
  })
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

M.on_attach = function(client, bufnr)
  utils.load_mappings("lspconfig", { buffer = bufnr })
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end
-------------------- on_attach logic ----------------------

-------------------- capablities logic --------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits",
  },
}

local present, ufo = pcall(require, "ufo")
if present then
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
end

M.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-------------------- capablities logic --------------------

local servers = settings.lsp_servers

local lsp_special_config = {
  clangd = {
    cmd = {
      "clangd",
      "--offset-encoding=utf-16",
    },
    capabilities = M.capabilities,
    on_attach = M.on_attach,
  },
  html = { filetypes = { "html", "htmldjango" } },
}

require("neodev").setup({})
for _, lsp in ipairs(servers) do
  local server_config = {
    before_init = function(_, config)
      if lsp == "pyright" then
        config.settings.python.pythonPath = require("plugins.configs.lsp.utils").get_python_path(config.root_dir)
        -- if lsp is pylsp do this:
        -- ~/.local/share/nvim/mason/packages/python-lsp-server/venv/bin/python3 -m pip install "python-lsp-server[all]"
      end
      -- if lsp == "pylsp" then
      --   config.settings.python.pythonPath = ""
      -- end
    end,
    on_attach = M.on_attach,
    capabilities = M.capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    settings = {
      Lua = lsp_settings.lua,
      yaml = lsp_settings.yaml,
    },
  }

  -- Merge special configuration if exists
  if lsp_special_config[lsp] then
    for k, v in pairs(lsp_special_config[lsp]) do
      server_config[k] = v
    end
  end

  nvim_lsp[lsp].setup(server_config)
end
