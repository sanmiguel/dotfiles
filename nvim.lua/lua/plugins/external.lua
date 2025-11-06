return {
  "mileszs/ack.vim",
  "tpope/vim-git",
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb", -- github support
  "airblade/vim-gitgutter",
  "whiteinge/diffconflicts",
  {
	  "ldelossa/gh.nvim",
	  dependencies = {
		  {
		  "ldelossa/litee.nvim",
		  config = function()
			  require("litee.lib").setup()
		  end,
		  },
	  },
	  config = function()
		  require("litee.gh").setup()
	  end,
  },
  {
	  "epwalsh/obsidian.nvim",
	  version = "*",
	  -- lazy = true,
	  -- ft = "markdown",
	  -- event = {
		-- "BufReadPre " .. vim.fn.expand "~" .. "/Obsidian/*.md",
		-- "BufNewFile " .. vim.fn.expand "~" .. "/Obsidian/*.md"
	  -- },
	  dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
		"nvim-treesitter/nvim-treesitter",
	  },
	  config = function()
		  vim.o.conceallevel = 1
		  require("obsidian").setup({
			completion = {
			  nvim_cmp = true,
			  min_chars = 2
			},
			workspaces = {
			  {
				name = "Personal",
				path = "~/Obsidian/Personal"
			  },
			},
			picker = {
			  name = "telescope.nvim",
			},
		  })
	  end,
  }

}
