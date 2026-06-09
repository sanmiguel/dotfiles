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
    config = function(_, opts)
      require("claudecode").setup(opts)
      -- Register custom MCP tools after the plugin initialises
      require("claudecode.tools.init").register(
        require("plugins.claudecode.set_quickfix_list")
      )

      -- Keep ~/.claude/ide/<port>.lock's workspaceFolders in sync with this nvim's
      -- live state. Upstream only writes the lockfile once at server start, so :cd
      -- and late-attaching LSP clients leave the advertised CWD stale — which
      -- causes Claude Code's /ide picker to misroute even when the CWDs match.
      local group = vim.api.nvim_create_augroup("ClaudeCodeLockfileSync", { clear = true })
      vim.api.nvim_create_autocmd({ "DirChanged", "LspAttach", "LspDetach" }, {
        group = group,
        callback = function()
          local state = require("claudecode").state
          if not state or not state.port or not state.auth_token then
            return
          end
          require("claudecode.lockfile").create(state.port, state.auth_token)
        end,
      })
    end,
    keys = {
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>",      mode = "v", desc = "Send to Claude" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",     desc = "Add buffer to Claude" },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",  desc = "Deny diff" },
      -- The "none" terminal provider disables :ClaudeCode, so the embedded chat
      -- window is gone. Restore it on demand here: launch Claude in a Snacks split
      -- with CLAUDE_CODE_SSE_PORT pointing at this nvim's live MCP server, so the
      -- chat auto-connects to *this* instance (no /ide needed) and can open diffs.
      {
        "<leader>ac",
        function()
          local state = require("claudecode").state
          if not state or not state.port then
            vim.notify("ClaudeCode server not running", vim.log.levels.WARN)
            return
          end
          require("snacks").terminal.toggle("claude", {
            env = {
              ENABLE_IDE_INTEGRATION = "true",
              FORCE_CODE_TERMINAL = "true",
              CLAUDE_CODE_SSE_PORT = tostring(state.port),
            },
            win = {
              position = "right",
              width = 0.35,
            },
          })
        end,
        desc = "Toggle embedded Claude chat",
      },
    },
  },
}
