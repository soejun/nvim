return {
  "CopilotC-Nvim/CopilotChat.nvim",
  enabled =false,
  opts = function()
    local user = "soejun"
    user = user:sub(1, 1):lower() .. user:sub(2)
    return {
      auto_insert_mode = true,
      question_header = "  " .. user .. " ",
      answer_header = "  Copilot ",
      window = {
        width = 0.3,
      },
      history_path = vim.fn.stdpath("data") .. "/copilotchat_history", -- Default path to stored history
      mappings = {
        close = {
          normal = "q",
          insert = "",
        },
        reset = {
          normal = "",
          insert = "",
        },
      },
    }
  end,
}
