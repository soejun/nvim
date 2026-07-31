return {
  "folke/snacks.nvim",
  init = function()
    -- Re-implementation of the explorer's follow_file (the builtin is
    -- disabled below): follow the current file on buffer switch, but pause
    -- while a search term is active so the filtered results stay put, and
    -- resume when the term is cleared. The builtin can't do this -- its
    -- reveal always wipes an active search.
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("snacks_explorer_follow", {}),
      callback = function(ev)
        vim.schedule(function()
          if not _G.Snacks or ev.buf ~= vim.api.nvim_get_current_buf() then
            return
          end
          local picker = Snacks.picker.get({ source = "explorer" })[1]
          if not picker or picker.closed or picker:is_focused() or not picker:on_current_tab() then
            return
          end
          if not picker.input.filter:is_empty() then
            return -- searching: keep the filtered results until the term is cleared
          end
          if vim.api.nvim_win_get_config(0).relative ~= "" then
            return
          end
          local file = vim.api.nvim_buf_get_name(0)
          local item = picker:current()
          if file == "" or (item and item.file == vim.fs.normalize(file)) then
            return
          end
          require("snacks.explorer.actions").update(picker, { target = file })
        end)
      end,
    })
  end,
  opts = {
    explorer = {},
    terminal = {
      win = {
        height = 0.27,
      },
      scroll = {
        animate = {
          duration = { step = 15, total = 150 },
        },
      },
    },
    picker = {
      sources = {
        explorer = {
          -- Builtin follow reveals on every buffer switch, which clears an
          -- active search (snacks.explorer.actions.update resets the input).
          -- Replaced by the search-aware autocmd in init above.
          follow_file = false,
          config = function(opts)
            -- setup() force-merges the stock confirm action over anything set
            -- in opts.actions, so it must be re-overridden after. The stock
            -- one reveals the file in the tree when a search is active, which
            -- wipes the search; jump directly so filtered results survive
            -- opening a file.
            opts = require("snacks.picker.source.explorer").setup(opts) or opts
            opts.actions.confirm = function(picker, item, action)
              if not item then
                return
              elseif item.dir then
                require("snacks.explorer.tree"):toggle(item.file)
                require("snacks.explorer.actions").update(picker, { refresh = true })
              else
                Snacks.picker.actions.jump(picker, item, action)
              end
            end
            return opts
          end,
        },
      },
    },
  },
-- URL for default bindings: https://www.lazyvim.org/extras/editor/snacks_picker
  -- stylua: ignore
  keys = {
    -- Note: Disable for No-Neck-Pain, use <leader>snt instead
    -- Disable keymap to pick snacks notifcations
    {"<leader>n", false},
      -- { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },

    -- TODO: Until we can make consistent disable our previous binding switch
    -- LazyVim docs imo switch the meaning of root dir and CWD, at least in a working sense,
    -- this is why we swap the =biindings here and set root = false
    -- { "<leader>/", LazyVim.pick("grep", { root = false }), desc = "Grep (cwd)" },
    { "<leader><space>", LazyVim.pick("files", { root = false, hidden=true, ignored=false}), desc = "Find Files (cwd)" },
    -- find
    -- { "<leader>fF", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
    -- { "<leader>ff", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
    -- grep
    -- { "<leader>sG", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
    -- { "<leader>sG", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
    { "<leader>/", LazyVim.pick("live_grep", { root = false, hidden=true, ignored=false}), desc = "Grep (cwd)" },
    -- { "<leader>sW", LazyVim.pick("grep_word"), desc = "Visual selection or word (Root Dir)", mode = { "n", "x" } },
    -- { "<leader>sw", LazyVim.pick("grep_word", { root = false }), desc = "Visual selection or word (cwd)", mode = { "n", "x" } },
  }
,
}
