return {
    {
        "iCyMind/NeoSolarized",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            -- load the colorscheme here
            vim.cmd.colorscheme([[NeoSolarized]])
        end,
        init = function()
            vim.g.neosolarized_italic = 1
            vim.g.neosolarized_termtrans = 1
            vim.g.neosolarized_contrast = "high"
            vim.g.neosolarized_diffmode = "high"
        end,
    },
  "folke/which-key.nvim", -- this might be able to replace quickmenu
  -- { "folke/neoconf.nvim", cmd = "Neoconf" }, -- manage project- and dir-specific configs
  "folke/neodev.nvim", -- helpers for working on init.lua and other neovim scripts
  "f-person/auto-dark-mode.nvim",
  {
      "vim-airline/vim-airline",
      init = function()
          vim.g.airline_powerline_fonts = 1
          vim.g.airline_left_sep = ''
          vim.g.airline_right_sep = ''
          vim.g.airline_section_b = ''
          vim.g.airline_theme = 'sanmiguelito'
      end,
  },
  {
      dir = "/opt/homebrew/opt/fzf",
      lazy = false,
      init = function()
      end
  },
  "junegunn/fzf.vim",
  "ibhagwan/fzf-lua"
}
