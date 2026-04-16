return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    event = "VeryLazy",
    opts = {
      -- Use "none" terminal provider so send/add commands don't open
      -- an embedded Claude terminal — we run Claude in a separate terminal
      -- and connect via /ide.
      terminal = {
        provider = "none",
      },
      diff_opts = {
        open_in_new_tab = true,
        layout = "vertical",
      },
    },
    keys = {
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>",      mode = "v", desc = "Send to Claude" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",     desc = "Add buffer to Claude" },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",  desc = "Deny diff" },
    },
  },
}
