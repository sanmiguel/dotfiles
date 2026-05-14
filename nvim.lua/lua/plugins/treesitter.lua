return {
  -- treesitter
  {
      "nvim-treesitter/nvim-treesitter",
      branch = 'main',
      lazy = false,
      build = ':TSUpdate',
      config = function()
          require('nvim-treesitter').install {
              "erlang", "elixir", "eex", "heex",
              "lua", "vim", "vimdoc", "query",
              "markdown", "markdown_inline",
          }
      end,
  },
  {
      "nvim-treesitter/nvim-treesitter-textobjects",
      branch = "main",
      config = function()
          require("nvim-treesitter-textobjects").setup {
              select = {
                  lookahead = true,
                  selection_modes = {
                      ['@parameter.outer'] = 'v', -- charwise
                      ['@function.outer'] = 'V', -- linewise
                      ['@class.outer'] = '<c-v>', -- blockwise
                  },
              },
          }

          -- Keymaps (replaces the old keymaps config)
          local select = require("nvim-treesitter-textobjects.select").select_textobject
          vim.keymap.set({ "x", "o" }, "af", function() select("@function.outer", "textobjects") end)
          vim.keymap.set({ "x", "o" }, "if", function() select("@function.inner", "textobjects") end)
          vim.keymap.set({ "x", "o" }, "ac", function() select("@class.outer", "textobjects") end)
          vim.keymap.set({ "x", "o" }, "ic", function() select("@class.inner", "textobjects") end)
          vim.keymap.set({ "x", "o" }, "as", function() select("@local.scope", "locals") end)
      end,
  },
}
