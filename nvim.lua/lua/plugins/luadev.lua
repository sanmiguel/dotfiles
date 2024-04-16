return {
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
}
