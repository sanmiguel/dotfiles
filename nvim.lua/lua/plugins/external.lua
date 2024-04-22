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
  }
}
