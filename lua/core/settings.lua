local M = {}

-- TODO: Install some sort of sorting plugin

M.global_statusline = true -- Toggle global status line
M.grepprg = "rg --hidden --vimgrep --smart-case --" -- use rg instead of grep, unused for now
M.showtabline = 1 -- enable or disable listchars
M.list = false
M.listchars = "eol:¬,tab:>·,trail:~,extends:>,precedes:<" -- which list chars to schow
M.enable_noice = true -- Noice heavily changes the Neovim UI ...
M.disable_winbar = false -- Disable winbar with nvim-navic location
M.dashboard_recent_files = 5 -- Number of recent files shown in dashboard, 0 disables showing recent files
M.disable_dashboard_header = false -- disable the header of the dashboard
M.disable_dashboard_quick_links = false -- disable quick links of the dashboard

M.treesitter_ensure_installed = {
  "awk",
  "asm",
  "bash",
  "c",
  "c_sharp",
  "cmake",
  "cpp",
  "css",
  "csv",
  "dockerfile",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "go",
  "gomod",
  "gosum",
  "ini",
  "html",
  "htmldjango",
  "http",
  "javascript",
  "jsdoc",
  "json",
  "json5",
  "jsonc",
  "latex",
  "lua",
  "luadoc",
  "make",
  "markdown",
  "markdown_inline",
  "meson",
  "nasm",
  "ninja",
  "nix",
  -- "powershell", -- this has been removed, install manually
  "python",
  "query",
  "r",
  "regex",
  "requirements",
  "scss",
  "toml",
  "tsv",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
  "vala",
}

M.lsp_servers = {
  "bashls",
  "clangd",
  "dockerls",
  "docker_compose_language_service",
  "gitlab_ci_ls",
  "jedi_language_server",
  "jsonls",
  "gopls",
  "html",
  "lua_ls",
  "marksman",
  -- "omnisharp", -- manually set this up as a separate conig
  "nginx_language_server",
  "tsserver",
  "yamlls",
  "vala_ls",
}

M.mason_ensure_installed = {
  "bash-language-server",
  "csharpier",
  "clangd",
  "docker-compose-language-service",
  "dockerfile-language-server",
  "gitlab-ci-ls",
  "gopls",
  "html-lsp",
  "htmx-lsp",
  "jedi-language-server",
  "json-lsp",
  "lua-language-server",
  "marksman",
  "netcoredbg",
  "nginx-language-server",
  "powershell-editor-services",
  "typescript-language-server",
  "yaml-language-server",
  "vala-language-server@0.48.7",
}

-- $ npm install --save markdown-toc
-- npm install markdownlint-cli2 --global
M.mason_ensure_install_tools = {
  "black",
  "debugpy",
  "eslint_d",
  "hadolint",
  "markdownlint-cli2",
  "pylint",
  "prettier",
  "ruff",
  "shellcheck",
  "shfmt",
  "stylua",
  "tflint",
  "vale",
  "xmlformatter",
  "yamllint",
  "yapf",
}

return M
