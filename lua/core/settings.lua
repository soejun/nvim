-- This file contains configuration settings for Vim-Options, TreeSitter, LSP servers, tools, and Telescope.
-- Instead of cluttering the individual configuration files with lengthy settings, we've organized them here to make it easier to manage and maintain the configuration.
-- For the love of god please rename this and reorganize your stuff

local M = {}
-- TODO: Cleanup, this is an initial glance for Allaman/nvim's settings
-- Toggle global status line
M.global_statusline = true
-- use rg instead of grep, unused for now
M.grepprg = "rg --hidden --vimgrep --smart-case --"

M.showtabline = 1
-- enable or disable listchars
M.list = false
-- which list chars to schow
M.listchars = "eol:¬,tab:>·,trail:~,extends:>,precedes:<"
-- Noice heavily changes the Neovim UI ...
M.enable_noice = true
-- Disable winbar with nvim-navic location
M.disable_winbar = false
-- Number of recent files shown in dashboard
-- 0 disables showing recent files
M.dashboard_recent_files = 5
-- disable the header of the dashboard
M.disable_dashboard_header = false
-- disable quick links of the dashboard
M.disable_dashboard_quick_links = false

-- treesitter parsers to be installed
-- one of "all", "maintained" (parsers with maintainers), or a list of languages
M.treesitter_ensure_installed = {
  -- we can always ask chatgpt to reorganize this list for us
  "bash",
  "css",
  "dockerfile",
  "go",
  "gomod",
  "gosum",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "query",
  "python",
  "regex",
  "scss",
  "toml",
  "typescript",
  "tsx", -- otherwise syntax highlighting won't work
  "vim",
  "vimdoc",
  "yaml",
}

-- LSPs that should be installed by Mason-lspconfig
M.lsp_servers = {
  "bashls",
  "clangd",
  "dockerls",
  "jsonls",
  "gopls",
  "html",
  "marksman",
  -- "jedi_language_server",
  -- Literally just make sure you run this command `sudo npm install pyright -g`
  "pyright",
  "lua_ls",
  "tsserver",
  "yamlls",
}
M.tools = {
  -- Formatter
  "black",
  "prettier",
  "stylua",
  "shfmt",
  -- Linter
  "eslint_d",
  "flake8",
  "shellcheck",
  "tflint",
  "yamllint",
  "pylint",
  "ruff",
  -- DAP
  "debugpy",
}
M.mason_ensure_installed = {
  "bash-language-server",
  "black",
  "clangd",
  "clang-format",
  "codelldb",
  "dockerfile-language-server",
  "eslint_d",
  "flake8",
  "json-lsp",
  "gopls",
  "html-lsp",
  "marksman",
  -- "pyright",
  "jedi-language-server",
  "lua-language-server",
  "ruff",
  "pylint",
  "tflint",
  "typescript-language-server",
  "yaml-language-server",
}

--Telescope
M.telescope_grep_hidden = true

-- which patterns to ignore in file switcher
M.telescope_file_ignore_patterns = {
  "%.7z",
  "%.JPEG",
  "%.JPG",
  "%.MOV",
  "%.RAF",
  "%.burp",
  "%.bz2",
  "%.cache",
  "%.class",
  "%.dll",
  "%.docx",
  "%.dylib",
  "%.epub",
  "%.exe",
  "%.flac",
  "%.ico",
  "%.ipynb",
  "%.jar",
  "%.jpeg",
  "%.jpg",
  "%.lock",
  "%.mkv",
  "%.mov",
  "%.mp4",
  "%.otf",
  "%.pdb",
  "%.pdf",
  "%.png",
  "%.rar",
  "%.sqlite3",
  "%.svg",
  "%.tar",
  "%.tar.gz",
  "%.ttf",
  "%.webp",
  "%.zip",
  ".git/",
  ".gradle/",
  ".idea/",
  ".settings/",
  ".vale/",
  ".vscode/",
  "__pycache__/*",
  "build/",
  "env/",
  "gradle/",
  "node_modules/",
  "smalljre_*/*",
  "target/",
  "vendor/*",
}

return M
