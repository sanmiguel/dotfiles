return {
    -- TODO: Split these up into chunks under plugins/
    -- e.g. plugins/treesitter.lua
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
  "mileszs/ack.vim",
  {
	  "folke/neodev.nvim", -- helpers for working on init.lua and other neovim scripts
	  dependencies = {
		  "nvim-neotest/neotest"
	  },
	  config = function() 
		  require("neodev").setup({
			  library = { plugins = { "neotest" }, types = true },
		  })
	  end,
  },
  {
	  "f-person/auto-dark-mode.nvim",
	  config = function()
		  require('auto-dark-mode').setup({
			  update_interval = 1000,
			  set_dark_mode = function()
				  vim.o.background = 'dark'
				  vim.cmd('colorscheme NeoSolarized')
			  end,
			  set_light_mode = function()
				  vim.o.background = 'light'
				  vim.cmd('colorscheme NeoSolarized')
			  end,
		  })
	  end,
  },
  -- {
  --     "vim-airline/vim-airline",
  --     init = function()
  --         vim.g.airline_powerline_fonts = 1
  --         vim.g.airline_left_sep = ''
  --         vim.g.airline_right_sep = ''
  --         vim.g.airline_section_b = ''
  --         vim.g.airline_theme = 'sanmiguelito'
  --     end,
  -- },

  {
	  "linrongbin16/lsp-progress.nvim",
	  config = function()
		  require("lsp-progress").setup({
			  decay = 1200,
			  series_format = function(title, message, percentage, done)
				  local builder = {}
				  local has_title = false
				  local has_message = false
				  if type(title) == "string" and string.len(title) > 0 then
					  local escaped_title = title:gsub("%%", "%%%%")
					  table.insert(builder, escaped_title)
					  has_title = true
				  end
				  if type(message) == "string" and string.len(message) > 0 then
					  local escaped_message = message:gsub("%%", "%%%%")
					  table.insert(builder, escaped_message)
					  has_message = true
				  end
				  if percentage and (has_title or has_message) then
					  table.insert(builder, string.format("(%.0f%%%%)", percentage))
				  end
				  return { msg = table.concat(builder, " "), done = done }
			  end,
			  client_format = function(client_name, spinner, series_messages)
				  if #series_messages == 0 then
					  return nil
				  end
				  local builder = {}
				  local done = true
				  for _, series in ipairs(series_messages) do
					  if not series.done then
						  done = false
					  end
					  table.insert(builder, series.msg)
				  end
				  if done then
					  spinner = "✓" -- replace your check mark
				  end
				  return "["
				  .. client_name
				  .. "] "
				  .. spinner
				  .. " "
				  .. table.concat(builder, ", ")
			  end,
		  })
	  end,
  },
  {
	  'nvim-lualine/lualine.nvim',
	  config = function()
		  require("lualine").setup({
			  options = {
				  -- component_separators = { left = '', right = '' },
				  component_separators = { left = '', right = '' },
				  --      
				  section_separators = { left = '', right = '' },
				  theme = "solarized_dark",
			  },
			  sections = {
				  lualine_a = { "mode" },
				  lualine_b = { "filename" },
				  lualine_c = {
					  -- invoke `progress` here.
					  require('lsp-progress').progress,
				  },
			  }
		  })

		  -- listen lsp-progress event and refresh lualine
		  vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
		  vim.api.nvim_create_autocmd("User", {
			  group = "lualine_augroup",
			  pattern = "LspProgressStatusUpdated",
			  callback = require("lualine").refresh,
		  })
	  end,
	  dependencies = {
		  'nvim-tree/nvim-web-devicons',
		  "linrongbin16/lsp-progress.nvim",
	  }
  },
  {
      dir = "/opt/homebrew/opt/fzf",
      lazy = false,
      init = function()
      end
  },
  "junegunn/fzf.vim",
  {
	  "ibhagwan/fzf-lua",
	  config = function()
		 require("fzf-lua").setup({ "fzf-vim" }) 
	  end,
	  dependencies = {
		  "nvim-tree/nvim-web-devicons",
	  }
  },
  {
	  'dominickng/fzf-session.vim',
	  config = function()
		  vim.g.fzf_session_path = vim.fn.stdpath("data") .. '/session'
		  kmopts = { noremap = true, silent = true }
		  vim.keymap.set("n", "<C-s><C-s>", "<cmd>:Sessions<CR>", kmopts)
	  end,
	  dependencies = {
		  "junegunn/fzf.vim"
	  }
  },
  -- treesitter
  {
      "nvim-treesitter/nvim-treesitter",
      config = function()
          vim.cmd([[TSUpdate]])
	  require'nvim-treesitter.configs'.setup {
		  -- A list of parser names, or "all" (the five listed parsers should always be installed)
		  ensure_installed = { "erlang", "elixir", "eex", "heex", "lua", "vim", "vimdoc", "query" },
		  -- Install parsers synchronously (only applied to `ensure_installed`)
		  sync_install = false,
		  -- Automatically install missing parsers when entering buffer
		  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
		  auto_install = true,
		  highlight = {
			  enable = true,
			  additional_vim_regex_highlighting = false,
		  },
		  textobjects = {
			  select = {
				  enable = true,

				  -- Automatically jump forward to textobj, similar to targets.vim
				  lookahead = true,

				  keymaps = {
					  -- You can use the capture groups defined in textobjects.scm
					  ["af"] = "@function.outer",
					  ["if"] = "@function.inner",
					  ["ac"] = "@class.outer",
					  -- You can optionally set descriptions to the mappings (used in the desc parameter of
					  -- nvim_buf_set_keymap) which plugins like which-key display
					  ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
					  -- You can also use captures from other query groups like `locals.scm`
					  ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
				  },
				  -- You can choose the select mode (default is charwise 'v')
				  --
				  -- Can also be a function which gets passed a table with the keys
				  -- * query_string: eg '@function.inner'
				  -- * method: eg 'v' or 'o'
				  -- and should return the mode ('v', 'V', or '<c-v>') or a table
				  -- mapping query_strings to modes.
				  selection_modes = {
					  ['@parameter.outer'] = 'v', -- charwise
					  ['@function.outer'] = 'V', -- linewise
					  ['@class.outer'] = '<c-v>', -- blockwise
				  },
				  -- If you set this to `true` (default is `false`) then any textobject is
				  -- extended to include preceding or succeeding whitespace. Succeeding
				  -- whitespace has priority in order to act similarly to eg the built-in
				  -- `ap`.
				  --
				  -- Can also be a function which gets passed a table with the keys
				  -- * query_string: eg '@function.inner'
				  -- * selection_mode: eg 'v'
				  -- and should return true of false
				  -- include_surrounding_whitespace = true,
			  },
		  },
	  }
      end,
  },
  "nvim-treesitter/nvim-treesitter-textobjects",
  "tpope/vim-git",
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb", -- github support
  "tpope/vim-rsi",
  "airblade/vim-gitgutter",
  "whiteinge/diffconflicts",

  --"tpope/vim-vinegar",
  "tpope/vim-unimpaired",
  {
	  "tpope/vim-surround",
	  config = function()
		  vim.g.surround_101 = "{:error, \r}" -- yse
		  vim.g.surround_111 = "{:ok, \r}" -- yso
		  vim.g.surround_110 = "{:noreply, \r}" -- ysn
		  vim.g.surround_114 = "{:reply, \1reply: \1, \2state: \2\r}"
		  vim.g.surround_37 = "%{\r: }" -- ys%
		  vim.g.surround_53 = "%{\"\r\" => }" -- ys5
		  vim.g.surround_58 = "\r:" --  ys:
		  vim.g.surround_59 = ":\r" -- ys;
		  vim.g.surround_124 = "|> \r" -- ys|
		  vim.g.surround_107 = ".\r" -- ysk
	  end
  },

  "tpope/vim-commentary",

  "elixir-lang/vim-elixir",
  -- TODO manage elixir-ls via lazy.nvim

  {
	  "neovim/nvim-lspconfig",
	  cmd = { "LspInfo", "LspInstall", "LspUninstall" },
	  event = { "BufReadPost", "BufNewFile" },
	  dependencies = {
		  -- { "williamboman/mason.nvim", config = true },
		  { "folke/neodev.nvim", config = true },
	  },
	  config = function()
		  require("lspconfig")["lua_ls"].setup({
			  settings = {
				  Lua = {
					  diagnostics = {
						  enable = true,
						  globals = { "vim" },
					  },
					  workspace = {
						  checkThirdParty = false,
					  },
				  },
			  },
		  })
		  require'lspconfig'.elixirls.setup{
			  -- on_attach = custom_attach, -- this may be required for extended functionalities of the LSP
			  -- capabilities = capabilities,
			  flags = {
				  debounce_text_changes = 150,
			  },
			  elixirLS = {
				  dialyzerEnabled = false,
				  fetchDeps = true,
			  };
		  }
	  end,
  },
  -- TODO https://elixirforum.com/t/neovim-elixir-setup-configuration-from-scratch-guide/46310
  -- hrsh7th/nvim-cmp
  --
  {
	  "mfussenegger/nvim-dap",
	  config = function()
		  require("dap").adapters.mix_task = {
			  type = "executable",
			  command = "/Users/sanmiguel/git/elixir-lsp/elixir-ls/release/debug_adapter.sh",
			  args = {}
		  }
		  require("dap").configurations.elixir = {
			  {
				  adapter = "mix_task",
				  type = "mix_task",
				  name = "mix test",
				  task = 'test',
				  taskArgs = {"--trace"},
				  request = "launch",
				  startApps = true, -- for Phoenix projects
				  projectDir = "${workspaceFolder}",
				  requireFiles = {
					  "test/**/test_helper.exs",
					  "test/**/*_test.exs"
				  }
			  },
		  }
	  end
  },
  {
      "nvim-neotest/neotest",
      dependencies = {
		  "nvim-neotest/nvim-nio",
		  "mfussenegger/nvim-dap",
          "nvim-lua/plenary.nvim",
          "antoinemadec/FixCursorHold.nvim",
          "nvim-treesitter/nvim-treesitter",
          "jfpedroza/neotest-elixir",
      },
	  config = function()
		  require("neotest").setup({
			  adapters = {
				  require("neotest-elixir"){
				  }
			  }
		  })
	  end,
  },
  "jfpedroza/neotest-elixir",
  -- "direnv/direnv.vim"
}
