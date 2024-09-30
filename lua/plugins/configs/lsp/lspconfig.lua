local utils = require("utils.functions")
local lsp_utils = require("plugins.configs.lsp.utils")
local nvim_lsp = require("lspconfig")
local configs = require("lspconfig.configs")
local settings = require("core.settings")
local lsp_settings = require("plugins.configs.lsp.settings")
local navic = require("nvim-navic")

local M = {}

-- TODO: fix
configs.jinja_lsp = {
  default_config = {
    name = "jinja-lsp",
    cmd = { "jinja-lsp" },
    filetypes = { "jinja", "rust", "htmldjango", "html" },
    root_dir = function(fname)
      return nvim_lsp.util.find_git_ancestor(fname)
    end,
    init_options = {
      templates = function()
        local root_directory = vim.fn.getcwd()
        local target_directory = "templates"
        return lsp_utils.find_path_from_root(root_directory, target_directory) or ""
      end,
      backend = function()
        return { vim.fn.getcwd() }
      end,
      lang = "python",
    },
  },
}

-------------------- on_attach logic ----------------------

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

M.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
-- set folding after capabilities from cmp_nvim_lsp to nvim-ufo can fold yaml
M.capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

-------------------- capablities logic --------------------

local servers = settings.lsp_servers

require("neodev").setup({})
for _, lsp in ipairs(servers) do
  local server_config = {
    before_init = function(_, config)
      -- jedi_language_server is capable of automatically detecting virtual environments
      -- if lsp == "jedi_language_server" then
      --   local lsp_utils = require("plugins.configs.lsp.utils")
      --   config.initializationOptions.workspace.environmentPath = lsp_utils.get_python_path(config.root_dir)
      -- end
    end,
    on_attach = M.on_attach,
    capabilities = M.capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    settings = {
      html = lsp_settings.html,
      Lua = lsp_settings.lua,
      yaml = lsp_settings.yaml,
    },
  }

  nvim_lsp[lsp].setup(server_config)
end

-- Omnisharp setup
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
local omnisharp_mason = vim.fn.stdpath("data") .. (is_windows and "\\mason\\bin\\omnisharp" or "/mason/bin/omnisharp")

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

-- powershell
local powershell_path = vim.fn.stdpath("data")
  .. (is_windows and "\\mason\\packages\\powershell-editor-services" or "/mason/packages/powershell-editor-services")
local powershell_config = {
  bundle_path = powershell_path,
  shell = "powershell.exe",
}
nvim_lsp.powershell_es.setup(powershell_config)

-- jinja-lsp
nvim_lsp.jinja_lsp.setup({
  capabilities = M.capabilities,
  on_attach = M.on_attach,
})
