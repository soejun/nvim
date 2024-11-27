local utils = require("utils.functions")
local nvim_lsp = require("lspconfig")
local settings = require("core.settings")
local lsp_settings = require("plugins.configs.lsp.settings")
local navic = require("nvim-navic")

local M = {}

M.on_attach = function(client, bufnr)
  utils.load_mappings("lspconfig", { buffer = bufnr })
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits",
  },
}

M.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
-- set folding after capabilities from cmp_nvim_lsp to nvim-ufo can fold yaml
M.capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

local basedpyright_settings = {
  typeCheckingMode = "off",
  analysis = {
    diagnosticMode = "workspace",
    inlayHints = {
      genericTypes = true,
    },
  },
}

local servers = settings.lsp_servers

require("neodev").setup({})
for _, lsp in ipairs(servers) do
  local server_config = {
    on_attach = M.on_attach,
    capabilities = M.capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    settings = {
      Lua = lsp_settings.lua,
      yaml = lsp_settings.yaml,
      basedpyright = basedpyright_settings,
    },
  }
  nvim_lsp[lsp].setup(server_config)
end

local html_config = {
  cmd = { "vscode-html-language-server", "--stdio" },
  filetypes = {
    "html",
    "templ",
    "htmldjango",
  },
  init_options = {
    configurationSection = { "html", "css", "javascript" },
    embeddedLanguages = {
      css = true,
      javascript = true,
    },
    provideFormatter = true,
  },
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  flags = {
    debounce_text_changes = 150,
  },
}
nvim_lsp.html.setup(html_config)

local omnisharp_mason = vim.fn.stdpath("data")
  .. (vim.g.is_windows and "\\mason\\bin\\omnisharp" or "/mason/bin/omnisharp")
local omnisharp_config = {
  cmd = { omnisharp_mason },
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  handlers = {
    ["textDocument/definition"] = function(...)
      return require("omnisharp_extended").handler(...)
    end,
  },
  keys = {
    {
      "gd",
      function()
        require("omnisharp_extended").telescope_lsp_definitions()
      end,
      desc = "Goto Definition",
    },
  },
  enable_roslyn_analyzers = true,
  organize_imports_on_format = true,
  enable_import_completion = true,
}
nvim_lsp.omnisharp.setup(omnisharp_config)

local powershell_path = vim.fn.stdpath("data")
  .. (
    vim.g.is_windows and "\\mason\\packages\\powershell-editor-services" or "/mason/packages/powershell-editor-services"
  )
nvim_lsp.powershell_es.setup({
  bundle_path = powershell_path,
  shell = "powershell.exe",
})
