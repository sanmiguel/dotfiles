return {
  "mileszs/ack.vim",
  "tpope/vim-git",
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb", -- github support
  {
	  "mrjones2014/op.nvim",
	  build = "make install",
	  config = function()
		  require("op").setup()
	  end,
  },
  {
	  "shumphrey/fugitive-gitlab.vim",
	  config = function()
		  vim.g.fugitive_gitlab_domains = {
			  ['gitlab.telesystems.hr'] = 'https://gitlab.telesystems.hr'
		  }
	  end
  },
  {
	"harrisoncramer/gitlab.nvim",
	dependencies = {
	  "MunifTanjim/nui.nvim",
	  "nvim-lua/plenary.nvim",
	  "sindrets/diffview.nvim",
	  "stevearc/dressing.nvim", -- Recommended but not required. Better UI for pickers.
	  "nvim-tree/nvim-web-devicons", -- Recommended but not required. Icons in discussion tree.
	},
	build = function () require("gitlab.server").build(true) end, -- Builds the Go binary
	config = function()
	  require("gitlab").setup({
		  gitlab_url = "https://gitlab.telesystems.hr",
		  auth_provider = function()
			  op = require("op")
			  get_secret = function()
				  return pcall(op.get_secret, "op://TeleSystems/Gitlab token/credential")
			  end
				  
			  local success, result = get_secret()

			  if not success then
				  local success, token = pcall(op.op_signin)
				  if not success then
					  return "notoken", string.format("https://signinfailed.example.com", result), nil
				  else
					  return token, "https://gitlab.telesystems.hr", nil
				  end
			  else
				  return result, "https://gitlab.telesystems.hr", nil
			  end
		  end,
	  })
	end,
  },
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
