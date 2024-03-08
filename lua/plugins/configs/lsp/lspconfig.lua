local utils = require("utils.functions")
local nvim_lsp = require("lspconfig")
local settings = require("core.settings")
local lsp_settings = require("plugins.configs.lsp.settings")
local navic = require("nvim-navic")

local M = {}

-- /home/wchan/.local/share/nvim/mason/packages/jedi-language-server

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

M.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
-- set folding after capabilities from cmp_nvim_lsp to nvim-ufo can fold yaml
M.capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

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

-- if lsp == "pyright" then
--   config.settings.python.pythonPath = require("plugins.configs.lsp.utils").get_python_path(config.root_dir)
-- end
-- example
-- cd /path/to/your/project
-- pyenv virtualenv 3.10.0 my_project_venv
-- pyenv local my_project_venv
-- pyenv activate my_project_venv
-- `pyenv versions` to see which ones are there
-- pipx should replace the roel of .venv-tools since it runs python stuff on isolated packages
-- we should utilize pipx for jupyter and anaconda and stuff

require("neodev").setup({})
for _, lsp in ipairs(servers) do
  local server_config = {
    before_init = function(_, config)
      if lsp == "jedi_language_server" then
        -- Amazing, just setup pyenv properly and jedi and null_ls sources should handle the rest!
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
      server_config[k] = v
    end
  end

  nvim_lsp[lsp].setup(server_config)
end
