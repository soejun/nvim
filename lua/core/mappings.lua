-- keymap settings for most plugins
-- <A-t> means alt+t, however in macOS it'd be <Option -t>

local M = {}

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

M.blankline = {
  plugin = true,
  n = {
    ["<leader>cc"] = {
      function()
        local ok, start = require("indent_blankline.utils").get_current_context(
          vim.g.indent_blankline_context_patterns,
          vim.g.indent_blankline_use_treesitter_scope
        )
        if ok then
          vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
          vim.cmd([[normal! _]])
        end
      end,

      "Jump to current_context",
    },
  },
}

M.dap = {
  plugin = true,
  n = {
    ["<leader>dB"] = {
      ':lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',
      "Breakpoint Condition",
    },
    ["<leader>db"] = { ':lua require("dap").toggle_breakpoint()<CR>', "Toggle Breakpoint" },
    ["<leader>dc"] = { ':lua require("dap").continue()<CR>', "Continue" },
    ["<leader>dC"] = { ':lua require("dap").run_to_cursor()<CR>', "Run to Cursor" },
    ["<leader>dg"] = { ':lua require("dap").goto_()<CR>', "Go to line (no execute)" },
    ["<leader>di"] = { ':lua require("dap").step_into()<CR>', "Step Into" },
    ["<leader>dj"] = { ':lua require("dap").down()<CR>', "Down" },
    ["<leader>dk"] = { ':lua require("dap").up()<CR>', "Up" },
    ["<leader>dl"] = { ':lua require("dap").run_last()<CR>', "Run Last" },
    ["<leader>do"] = { ':lua require("dap").step_out()<CR>', "Step Out" },
    ["<leader>dO"] = { ':lua require("dap").step_over()<CR>', "Step Over" },
    ["<leader>dp"] = { ':lua require("dap").pause()<CR>', "Pause" },
    ["<leader>dr"] = { ':lua require("dap").repl.open()<CR>', "Repl" },
    ["<leader>ds"] = { ':lua require("dap").session()<CR>', "Session" },
    ["<leader>dt"] = { ':lua require("dap").terminate()<CR>', "Terminate" },
    ["<leader>dw"] = { ':lua require("dap.ui.widgets").hover()<CR>', "Hover" },
  },
}

M.go = {
  plugin = true,
  n = {
    ["<leader>gc"] = { "<cmd>GoCodeLenAct<CR>" },
    ["<leader>ga"] = { "<cmd>GoCodeAction<CR>" },
  },
}
M.comment = {
  plugin = true,
  -- toggle comment in both modes
  n = {
    ["<leader>/"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "toggle comment",
    },
  },
  v = {
    ["<leader>/"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "toggle comment",
    },
  },
}

M.lspconfig = {
  plugin = true,
  -- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions
  n = {
    ["gD"] = {
      function()
        vim.lsp.buf.declaration()
      end,
      "lsp declaration",
    },
    ["gd"] = {
      function()
        vim.lsp.buf.definition()
      end,
      "lsp definition",
    },
    ["K"] = {
      function()
        vim.lsp.buf.hover()
      end,
      "lsp hover",
    },
    ["gi"] = {
      function()
        vim.lsp.buf.implementation()
      end,
      "lsp implementation",
    },
    ["<leader>ls"] = {
      function()
        vim.lsp.buf.signature_help()
      end,
      "lsp signature_help",
    },
    ["<leader>D"] = {
      function()
        vim.lsp.buf.type_definition()
      end,
      "lsp definition type",
    },
    ["<leader>ca"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "lsp code_action",
    },
    ["gr"] = {
      function()
        vim.lsp.buf.references()
      end,
      "lsp references",
    },
    ["<leader>f"] = {
      function()
        vim.diagnostic.open_float({ border = "rounded" })
      end,
      "floating diagnostic",
    },
    ["[d"] = {
      function()
        vim.diagnostic.goto_prev()
      end,
      "goto prev",
    },
    ["]d"] = {
      function()
        vim.diagnostic.goto_next()
      end,
      "goto_next",
    },
    ["<leader>q"] = {
      function()
        vim.diagnostic.setloclist()
      end,
      "diagnostic setloclist",
    },
    ["<leader>fm"] = {
      function()
        vim.lsp.buf.format({ async = true })
      end,
      "lsp formatting",
    },
    ["<leader>tF"] = {
      "<cmd>lua require('plugins.configs.lsp.utils').toggle_autoformat()<cr>",
      {
        desc = "Toggle format on save",
      },
    },
    ["<leader>wa"] = {
      function()
        vim.lsp.buf.add_workspace_folder()
      end,
      "add workspace folder",
    },
    ["<leader>wr"] = {
      function()
        vim.lsp.buf.remove_workspace_folder()
      end,
      "remove workspace folder",
    },
    ["<leader>wl"] = {
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      "list workspace folders",
    },
  },
}

M.notify = {
  plugin = true,
  n = {
    -- clear notifications
    ["<leader><Esc>"] = { ":lua require('notify').dismiss()<CR>", opts = { silent = true } },
  },
}
M.nvimtree = {
  plugin = true,
  n = {
    ["<C-n>"] = { "<cmd> NvimTreeToggle <CR>", "toggle nvimtree" },
    ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "focus nvimtree" },
  },
}

M.whichkey = {
  plugin = true,
  n = {
    ["<leader>wK"] = { "<cmd>WhichKey<CR>", desc = "which-key all keymaps" },
    ["<leader>wk"] = {
      function()
        local input = vim.fn.input("WhichKey: ")
        vim.cmd("WhichKey " .. input)
      end,
      "which-key query lookup",
    },
  },
}

M.telescope = {
  plugin = true,
  n = {
    -- find
    ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "find files" },
    ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "find all" },
    ["<leader>fw"] = { "<cmd> Telescope live_grep <CR>", "live grep" },
    ["<leader>fb"] = { "<cmd> Telescope buffers <CR>", "find buffers" },
    ["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "help page" },
    ["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "find oldfiles" },
    ["<leader>fs"] = { "<cmd> Telescope current_buffer_fuzzy_find <CR>", "find in current buffer" },
    -- git
    ["<leader>cm"] = { "<cmd> Telescope git_commits <CR>", "git commits" },
    ["<leader>gt"] = { "<cmd> Telescope git_status <CR>", "git status" },
    -- pick a hidden term
    ["<leader>pt"] = { "<cmd> Telescope terms <CR>", "pick hidden term" },
  },
}

M.toggleterm = {
  plugin = true,
  n = {
    -- toggle in normal mode
    ["<leader>v"] = { "<cmd>ToggleTerm direction=vertical<CR>", desc = "toggle vertical term" },
    ["<leader>h"] = { "<cmd>ToggleTerm direction=horizontal<CR>", desc = "toggle horizontal term" },
  },
  t = {
    -- toggle in terminal mode
    ["<leader>v"] = { "<cmd>ToggleTerm direction=vertical<CR>", desc = "toggle vertical term" },
    ["<leader>h"] = { "<cmd>ToggleTerm direction=horizontal<CR>", desc = "toggle horizontal term" },
  },
}

M.ufo = {
  plugin = true,
  n = {
    ["zR"] = { ":lua require('ufo').openAllFolds()<CR>" },
    ["zM"] = { ":lua require('ufo').closeAllFolds()<CR>" },
  },
}

M.webtools = {
  plugin = true,
  n = {
    ["<leader>bsc"] = { "<cmd>BrowserSync<CR>", desc = "BrowserSync live" },
  },
}

return M
