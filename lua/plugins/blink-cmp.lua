return {
  "saghen/blink.cmp",
  opts = {
    completion = {
      accept = {
        -- experimental auto-brackets support
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        border = "rounded",
        -- winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
        -- winblend = 0,
        draw = {
          treesitter = { "lsp" },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = "rounded",
          -- winhighlight = "Normal:Normal,FloatBorder:SnacksPickerBoxBorder,CursorLine:BlinkCmpDocCursorLine,Search:SnacksPickerBoxBorder",
        },
      },
      ghost_text = {
        enabled = vim.g.ai_cmp,
      },
    },
  },
}
