local opt = vim.opt
local settings = require("core.settings")

-- OS check, to account for clipboard and binary locations
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"

vim.g.mapleader = " "

vim.g.deprecation_warnings = false
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

if settings.global_statusline then
  opt.laststatus = 3 -- global statusline
else
  opt.laststatus = 2
end

opt.clipboard = "unnamedplus"
opt.winbar = "%{%v:lua.require'utils.winbar'.get_winbar()%}"
opt.spelllang = "en"
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 0 -- Hide * markup for bold and italic, but not markers with substitutions

-- Indenting
opt.expandtab = true
opt.shiftround = true -- Round indent
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2
opt.list = true -- show some invisible characters (tabs..)

-- nvim-ufo folding
opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

opt.shortmess:append("sI") -- disable nvim intro
opt.linebreak = true -- Wrap lines at convenient points
opt.cursorline = true
opt.mouse = "a"
opt.inccommand = "nosplit" -- preview incremental substitute
opt.ignorecase = true
opt.smartcase = true
opt.number = true
opt.numberwidth = 2
opt.ruler = false
opt.wrap = false
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.sidescrolloff = 8 -- Columns of context
opt.splitbelow = true
opt.splitright = true
opt.timeoutlen = 400
opt.undofile = true
opt.undolevels = 10000
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.updatetime = 200 -- interval for writing swap file to disk, also used by gitsigns


-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")

-- Add binaries installed by mason.nvim to PATH
local path_separator = is_windows and ";" or ":"
local mason_bin_path = vim.fn.stdpath("data") .. (is_windows and "\\mason\\bin" or "/mason/bin")
vim.env.PATH = vim.env.PATH .. path_separator .. mason_bin_path

vim.api.nvim_set_var(
  "guicursor",
  "n-v-c:block-Cursor/lCursor-blinkon0,i-ci-ve:ver25-Cursor/lCursor-blinkon0,r-cr:hor20-Cursor/lCursor-blinkon0"
)

vim.o.cmdheight = 1
vim.o.title = true
vim.o.titlestring = "nvim/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
vim.o.titleold = "Terminal"

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
