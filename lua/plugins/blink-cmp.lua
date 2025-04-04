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
        draw = {
          treesitter = { "lsp" },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:GruvboxBg4,CursorLine:BlinkCmpDocCursorLine,Search:None",
        },
      },
      ghost_text = {
        enabled = vim.g.ai_cmp,
      },
    },
  },
}
