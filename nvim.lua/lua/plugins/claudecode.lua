return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<cr>",         desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",     desc = "Focus Claude" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>",      mode = "v", desc = "Send to Claude" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",     desc = "Add buffer to Claude" },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",  desc = "Deny diff" },
    },
  },
}
