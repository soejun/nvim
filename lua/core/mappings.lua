-- keymap settings for most plugins
-- <A-t> means alt+t, however in macOS it'd be <Option -t>

local M = {}
local utils = require("utils.functions")

-- format
-- [binding] = {command, description}
-- example: ["<C-b>"] = { "<ESC>^i", "beginning of line" },

local diagnostics_visible = true
function ToggleDiagnostics()
  diagnostics_visible = not diagnostics_visible
  vim.diagnostic.config({
    virtual_text = diagnostics_visible,
    underline = diagnostics_visible,
    -- You can add other diagnostic configurations here if needed
  })
end

function ToggleSpellCheck()
  local current_value = vim.wo.spell
  vim.wo.spell = not current_value
end

function TrimTrailingWhiteSpace()
  local save_cursor = vim.fn.getpos(".")
  local save_search = vim.fn.getreg("/")
  vim.cmd([[%s/\s\+$//e]])
  vim.fn.setpos(".", save_cursor)
  vim.fn.setreg("/", save_search)
  utils.notify("Trailing whitespace trimmed for current buffer", vim.log.levels.OFF)
end

M.general = {
  i = {
    -- go to  beginning and end
    ["<C-b>"] = { "<ESC>^i", "beginning of line" },
    ["<C-e>"] = { "<End>", "end of line" },
    -- navigate within insert mode
    ["<C-h>"] = { "<Left>", "move left" },
    ["<C-l>"] = { "<Right>", "move right" },
    ["<C-j>"] = { "<Down>", "move down" },
    ["<C-k>"] = { "<Up>", "move up" },
    -- exit insert mode
    ["jk"] = { "<ESC>", "exit insert mode" },
  },
  n = {
    ["<leader>nh"] = { ":noh <CR>", "clear highlights" },
    -- spellcheck and diagnostics
    ["<leader>te"] = { ":lua ToggleDiagnostics()<CR>", "toggle diagnostics" },
    ["<leader>ts"] = { ":lua ToggleSpellCheck()<CR>", "toggle spellcheck" },
    -- trim trailing whitespaces
    ["<leader>tw"] = { ":lua TrimTrailingWhiteSpace()<CR>", "trim trailing whitespaces" },
    -- switch between windows
    ["<C-h>"] = { "<C-w>h", "window left" },
    ["<C-l>"] = { "<C-w>l", "window right" },
    ["<C-j>"] = { "<C-w>j", "window down" },
    ["<C-k>"] = { "<C-w>k", "window up" },
    -- window sizing management
    ["<leader>sv"] = { "<C-w>v", "split window vertically" },
    ["<leader>sh"] = { "<C-w>s", "split window horizontally" },
    ["<leader>se"] = { "<C-w>=", "windows equal width and height" },
    ["<leader>sx"] = { ":close<CR>", "close current split window" },
    -- save
    ["<C-s>"] = { "<cmd> w <CR>", "save file" },
    -- Copy all
    ["<C-c>"] = { "<cmd> %y+ <CR>", "copy whole file" },
    -- line numbers
    -- ["<leader>n"] = { "<cmd> set nu! <CR>", "toggle line number" },
    -- ["<leader>rn"] = { "<cmd> set rnu! <CR>", "toggle relative number" },

    -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
    -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
    -- empty mode is same as using <cmd> :map
    -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "move down", opts = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "move up", opts = { expr = true } },
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "move up", opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "move down", opts = { expr = true } },
    -- new buffer
    ["<leader>b"] = { "<cmd> enew <CR>", "new buffer" },
  },
  v = {
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "move up", opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "move down", opts = { expr = true } },
  },
  x = {
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "move down", opts = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "move up", opts = { expr = true } },
    -- Don't copy the replaced text after pasting in visual mode
    -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
    ["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', "dont copy replaced text", opts = { silent = true } },
  },
}

-- M.blankline = {
--   plugin = true,
--   n = {
--     ["<leader>cc"] = {
--       function()
--         local ok, start = require("indent_blankline.utils").get_current_context(
--           vim.g.indent_blankline_context_patterns,
--           vim.g.indent_blankline_use_treesitter_scope
--         )
--         if ok then
--           vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
--           vim.cmd([[normal! _]])
--         end
--       end,
--
--       "Jump to current_context",
--     },
--   },
-- }

  -- stylua: ignore start
M.conform = {
  n = {
    ["<leader>fm"] = { function() require("conform").format({ async = true, lsp_format = "fallback" }) end, "format buffer", },
  },
  -- conform will format only selection if in visual mode
  v = {
    ["<leader>fm"] = { function() require("conform").format({ async = true, lsp_format = "fallback" }) end, "format buffer", },
  },
}

M.dap = {
  plugin = true,
  n = {
    ["<leader>dB"] = {
      function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
      "Breakpoint Condition",
    },
    ["<leader>db"] = { function() require("dap").toggle_breakpoint() end, "Toggle Breakpoint", },
    ["<leader>dc"] = { function() require("dap").continue() end, "Continue" },
    ["<leader>dC"] = { function() require("dap").run_to_cursor() end, "Run to Cursor", },
    ["<leader>dg"] = { function() require("dap").goto_() end, "Go to line (no execute)", },
    ["<leader>di"] = { function() require("dap").step_into() end, "Step Into", },
    ["<leader>dj"] = { function() require("dap").down() end, "Down", },
    ["<leader>dk"] = { function() require("dap").up() end, "Up", },
    ["<leader>dl"] = { function() require("dap").run_last() end, "Run Last", },
    ["<leader>do"] = { function() require("dap").step_out() end, "Step Out", },
    ["<leader>dO"] = { function() require("dap").step_over() end, "Step Over", },
    ["<leader>dp"] = { function() require("dap").pause() end, "Pause", },
    ["<leader>dr"] = { function() require("dap").repl.toggle() end, "Toggle REPL", },
    ["<leader>ds"] = { function() require("dap").session() end, "Session", },
    ["<leader>dt"] = { function() require("dap").terminate() end, "Terminate", },
    ["<leader>dw"] = { function() require("dap.ui.widgets").hover() end, "Widgets", },
  },
}

M.dap_ui = {
  plugin = true,
  n = {
    ["<leader>du"] = { function() require("dapui").toggle() end, "Toggle dap-ui", },
    ["<leader>de"] = { function() require("dapui").eval() end, "Evaluate dap-ui",
    },
  },
}

M.go = {
  plugin = true,
  n = {
    ["<leader>gc"] = { "<cmd>GoCodeLenAct<CR>", "GoCodeLenAct" },
    ["<leader>ga"] = { "<cmd>GoCodeAction<CR>", "GoCodeAction" },
  },
}
M.comment = {
  plugin = true,
  -- toggle comment in both modes
  n = {
    ["<leader>/"] = { function() require("Comment.api").toggle.linewise.current() end, "toggle comment",
    },
  },
  v = {
    ["<leader>/"] = { "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", "toggle comment", },
  },
}

M.lspconfig = {
  plugin = true,
  n = {
    -- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions
    ["<leader>gD"] = { function() vim.lsp.buf.declaration() end, "lsp declaration", },
    ["gd"] = { function() vim.lsp.buf.definition() end, "lsp definition", },
    ["<leader>gd"] = { function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, "lsp definition", },
    ["K"] = { function() vim.lsp.buf.hover() end, "lsp hover; press twice to jump into window", },
    ["gi"] = { function() vim.lsp.buf.implementation() end, "lsp implementation", },
    ["<leader>ls"] = { function() vim.lsp.buf.signature_help() end, "lsp signature_help", },
    -- ["<leader>D"] = { function() vim.lsp.buf.type_definition() end, "lsp definition type", },
    ["<leader>D"] = { function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, "lsp definition type", },
    ["<leader>ca"] = { function() vim.lsp.buf.code_action() end, "lsp code_action", },
    ["<leader>gr"] = { function() vim.lsp.buf.references() end, "lsp references", },
    ["<leader>f"] = { function() vim.diagnostic.open_float({ border = "rounded" }) end, "floating diagnostic", },
    ["[d"] = { function() vim.diagnostic.goto_prev() end, "goto prev", },
    ["]d"] = { function() vim.diagnostic.goto_next() end, "goto_next", },
    ["<leader>q"] = { function() vim.diagnostic.setloclist() end, "diagnostic setloclist", },
    -- DEPRECATED handle formatting with conform instead
    -- ["<leader>fm"] = { function() vim.lsp.buf.format({ async = true }) end, "lsp formatting", },
    ["<leader>wa"] = { function() vim.lsp.buf.add_workspace_folder() end, "add workspace folder", },
    ["<leader>wr"] = { function() vim.lsp.buf.remove_workspace_folder() end, "remove workspace folder", },
    ["<leader>wl"] = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "list workspace folders", },
  },
}

M.notify = {
  plugin = true,
  n = {
    ["<leader><Esc>"] = { ":lua require('notify').dismiss()<CR>", "clear notifications", opts = { silent = true },
    },
  },
}
M.nvimtree = {
  plugin = true,
  n = {
    ["<C-n>"] = { "<cmd> NvimTreeToggle <CR>", "toggle nvimtree" },
    ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "focus nvimtree" },
  },
}
M.outline_nvim = {
  plugin = true,
  n = {
    -- A lot of keys are in outline_opts fyi as defaults
    ["<leader>o"] = { "<cmd>Outline<CR>", "Toggle outline" },
  },
}

M.render_markdown = {
  plugin = true,
  n = {
    ["<leader>um"] = {":lua require('render-markdown').toggle()<CR>", "toggle render-markdown"}
  }
}

-- ctrl+y, move screen up one line
-- ctrl+e, move screen down one line
M.whichkey = {
  plugin = true,
  n = {
    ["<leader>wK"] = { "<cmd>WhichKey<CR>", "which-key all keymaps" },
    ["<leader>wk"] = { function() local input = vim.fn.input("WhichKey: ") vim.cmd("WhichKey " .. input) end, "which-key query lookup", },
  },
}

M.telescope = {
  plugin = true,
  n = {
    -- searching stuff
    ["<leader>sc"] = { "<cmd> Telescope commands <CR>", "commands" },
    ["<leader>sK"] = { "<cmd> Telescope keymaps <CR>", "keymaps" },
    ["<leader>sO"] = { "<cmd> Telescope vim_options <CR>", "vim options" },
    ["<leader>s;"] = { "<cmd> Telescope command_history <CR>", "command history" },
    ["<leader>s?"] = { "<cmd> Telescope help_tags <CR>", "help page" },
    ["<leader>sw"] = { "<cmd> Telescope grep_string<CR>", "string under cursor" },
    ["<leader>ss"] = { "<cmd> Telescope live_grep <CR>", "live grep" },
    ["<leader>sW"] = { "<cmd>lua require'telescope.builtin'.grep_string{ shorten_path = true, word_match = '-w', only_sort_text = true, search = '' }<cr>",
      "Word search",
    },
    ["<C-f>"] = {"<cmd>Telescope current_buffer_fuzzy_find<cr>", "Search in buffer"},
    -- files
    ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "find files" },
    ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "find all" },
    ["<leader>fr"] = { "<cmd> Telescope oldfiles <CR>", "find oldfiles" },
    -- LSP Related
    ["<leader>ld"] = { "<cmd> Telescope lsp_document_symbols <CR> ", "lists LSP document symbols in current buffer" },
    ["<leader>lw"] = { "<cmd> Telescope lsp_workspace_symbols<CR> ", "lists LSP document symbols in current buffer" },
    ["gr"] = { "<cmd> Telescope lsp_references<CR> ", "lists LSP references under cursor in telescope", },
    ["<leader>td"] = { "<cmd> Telescope diagnostics bufnr=0<CR> ", "lists all diagnostics for current buffer in telescope", },
    -- git
    ["<leader>gm"] = { "<cmd> Telescope git_commits <CR>", "git commits" },
    ["<leader>gt"] = { "<cmd> Telescope git_status <CR>", "git status" },
    ["<leader>gb"] = { "<cmd> Telescope git_branches<CR>", "git branches" },

    -- misc
    ["<leader>mt"] = {"<cmd> Telescope <CR>", "Telescope"},
    ["<leader>bb"] = { "<cmd> Telescope buffers <CR>", "buffer list" },
    -- pick a hidden term
    ["<leader>pt"] = {
      "<cmd> Telescope find_files follow=false no_ignore=false hidden=true<CR>",
      "find hidden",
    },
  },
}

M.toggleterm = {
  plugin = true,
  n = {
    -- toggle in normal mode
    ["<leader>V"] = { "<cmd>ToggleTerm direction=vertical<CR>", "toggle vertical term" },
    ["<leader>H"] = { "<cmd>ToggleTerm direction=horizontal<CR>", "toggle horizontal term" },
    ["<leader>F"] = { "<cmd> ToggleTerm direction=float<CR>", "toggle floating term" },
  },
  t = {
    -- toggle in terminal mode
    ["<leader>V"] = { "<cmd>ToggleTerm direction=vertical<CR>", "toggle vertical term" },
    ["<leader>H"] = { "<cmd>ToggleTerm direction=horizontal<CR>", "toggle horizontal term" },
  },
}

M.ufo = {
  plugin = true,
  n = {
    ["zR"] = { ":lua require('ufo').openAllFolds()<CR>", "open all folds" },
    ["zM"] = { ":lua require('ufo').closeAllFolds()<CR>", "close all folds" },
  },
}

M.webtools = {
  plugin = true,
  n = {
    ["<leader>bsc"] = { "<cmd>BrowserSync<CR>", "BrowserSync live" },
  },
}

M.vim_tmux_navigator = {
  plugin = true,
  n = {
    ["<C-h>"] = { "<cmd>TmuxNavigateLeft<CR>", "Navigate to the left Tmux pane" },
    ["<C-j>"] = { "<cmd>TmuxNavigateDown<CR>", "Navigate to the bottom Tmux pane" },
    ["<C-k>"] = { "<cmd>TmuxNavigateUp<CR>", "Navigate to the top Tmux pane" },
    ["<C-l>"] = { "<cmd>TmuxNavigateRight<CR>", "Navigate to the right Tmux pane" },
    ["<C-\\>"] = { "<cmd>TmuxNavigatePrevious<CR>", "Navigate to the previous Tmux pane" },
  },
}

M.vim_dadbod = {
  plugin = true,
  n = {
    ["<leader>Dt"] = { "<cmd>DBUIToggle<cr>", "Toggle UI" },
    ["<leader>Df"] = { "<cmd>DBUIFindBuffer<cr>", "Find Buffer" },
    ["<leader>Dr"] = { "<cmd>DBUIRenameBuffer<cr>", "Rename Buffer" },
    ["<leader>Dq"] = { "<cmd>DBUILastQueryInfo<cr>", "Last Query Info" },
  },
}

-- stylua: ignore end
return M
