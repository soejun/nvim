return {
  -- community fork
  "obsidian-nvim/obsidian.nvim",
  -- enabled = false,
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  cmd = "Obsidian",
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
  },
  -- Vault-wide actions under <leader>o. The prefix is unused by this config
  -- and by LazyVim core; of the LazyVim extras only overseer (not enabled)
  -- claims it. Note-scoped maps live in callbacks.enter_note below.
  keys = {
    { "<leader>o", "", desc = "+obsidian", mode = { "n", "v" } },
    { "<leader>oo", "<cmd>Obsidian quick_switch<cr>", desc = "Find Note" },
    { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Search Vault" },
    { "<leader>on", "<cmd>Obsidian new<cr>", desc = "New Note" },
    { "<leader>oN", "<cmd>Obsidian new_from_template<cr>", desc = "New Note from Template" },
    { "<leader>ot", "<cmd>Obsidian today<cr>", desc = "Today's Daily Note" },
    { "<leader>oy", "<cmd>Obsidian yesterday<cr>", desc = "Yesterday's Daily Note" },
    { "<leader>oT", "<cmd>Obsidian tomorrow<cr>", desc = "Tomorrow's Daily Note" },
    { "<leader>od", "<cmd>Obsidian dailies<cr>", desc = "Daily Notes" },
    { "<leader>og", "<cmd>Obsidian tags<cr>", desc = "Tags" },
    { "<leader>oO", "<cmd>Obsidian open<cr>", desc = "Open in Obsidian App" },
  },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    ui = { enable = false },
    legacy_commands = false,
    workspaces = {
      {
        name = "Pengyou",
        path = "~/Documents/Pengyou",
      },
    },
    -- Completion is served by the plugin's built-in obsidian-ls LSP server
    -- (the old nvim_cmp/blink flags are deprecated no-ops); blink.cmp picks
    -- it up through its LSP source.
    completion = {
      -- Trigger completion at 2 chars.
      min_chars = 2,
    },
    callbacks = {
      -- Buffer-local maps for vault notes only (the deprecated top-level
      -- `mappings` table no longer has any effect). The plugin itself also
      -- maps <CR> (smart action) and ]o / [o (next/prev link) in notes.
      enter_note = function()
        local function bmap(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = true, desc = desc })
        end
        bmap("n", "<leader>ob", "<cmd>Obsidian backlinks<cr>", "Backlinks")
        bmap("n", "<leader>oc", "<cmd>Obsidian toggle_checkbox<cr>", "Toggle Checkbox")
        bmap("n", "<leader>or", "<cmd>Obsidian rename<cr>", "Rename Note (Updates Backlinks)")
        bmap("n", "<leader>op", "<cmd>Obsidian paste_img<cr>", "Paste Image")
        bmap("n", "<leader>oi", "<cmd>Obsidian template<cr>", "Insert Template")
        bmap("n", "<leader>ol", "<cmd>Obsidian links<cr>", "Note Links")
        bmap("v", "<leader>ol", ":Obsidian link<cr>", "Link to Existing Note")
        bmap("v", "<leader>oL", ":Obsidian link_new<cr>", "Link to New Note")
        bmap("v", "<leader>oe", ":Obsidian extract_note<cr>", "Extract to New Note")
      end,
    },
    picker = {
      -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', 'mini.pick' or 'snacks.pick'.
      name = "snacks.pick",
      -- Optional, configure key mappings for the picker. These are the defaults.
      -- Not all pickers support all mappings.
      note_mappings = {
        -- Create a new note from your query.
        new = "<C-x>",
        -- Insert a link to the selected note.
        insert_link = "<C-l>",
      },
      tag_mappings = {
        -- Add tag(s) to current note.
        tag_note = "<C-x>",
        -- Insert a tag at the current location.
        insert_tag = "<C-l>",
      },
    },
  },
}
