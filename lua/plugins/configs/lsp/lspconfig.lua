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

M.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
-- set folding after capabilities from cmp_nvim_lsp to nvim-ufo can fold yaml
M.capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

-------------------- capablities logic --------------------

local servers = settings.lsp_servers

-- c# binaries for lsp
local omnisharp_bin_mason = "/home/wchan/.local/share/nvim/mason/bin/omnisharp"
local csharp_ls_binary = "/home/wchan/.dotnet/tools/csharp-ls"
local pid = vim.fn.getpid()

local lsp_special_config = {
  clangd = {
    cmd = {
      "clangd",
      "--offset-encoding=utf-16",
    },
    capabilities = M.capabilities,
    on_attach = M.on_attach,
  },
  csharp_ls = {
    cmd = { csharp_ls_binary },
    filetypes = { "cs", "vb" },
    on_attach = M.on_attach,
    capabilities = M.capabilities,
  },
  html = { filetypes = { "html", "htmldjango" } },
  --   omnisharp = {
  --   handlers = {
  --     ["textDocument/definition"] = function(...)
  --       return require("omnisharp_extended").handler(...)
  --     end,
  --   },
  --   keys = {
  --     {
  --       "gd",
  --       function()
  --         require("omnisharp_extended").telescope_lsp_definitions()
  --       end,
  --       desc = "Goto Definition",
  --     },
  --   },
  --   enable_roslyn_analyzers = true,
  --   organize_imports_on_format = true,
  --   enable_import_completion = true,
  --   cmd = {
  --     omnisharp_bin_mason,
  --     "--languageserver",
  --     "--hostPID",
  --     tostring(pid),
  --   },
  -- },
}

require("neodev").setup({})
for _, lsp in ipairs(servers) do
  local server_config = {
    before_init = function(_, config)
      -- jedi_language_server is capable of automatically detecting virtual environments
      if lsp == "jedi_language_server" then
        local lsp_utils = require("plugins.configs.lsp.utils")
        config.initializationOptions.workspace.environmentPath = lsp_utils.get_python_path(config.root_dir)
      end
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
      if type(server_config[k]) == "table" and type(v) == "table" then
        server_config[k] = vim.tbl_deep_extend("force", server_config[k], v)
      else
        server_config[k] = v
      end
    end
  end

  nvim_lsp[lsp].setup(server_config)
end
