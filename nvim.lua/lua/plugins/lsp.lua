return {
	{
	  "j-hui/fidget.nvim",
	  opts = {
		-- options
	  },
	},
	{
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo", "LspInstall", "LspUninstall" },
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			-- { "williamboman/mason.nvim", config = true },
			{ "folke/neodev.nvim", config = true },
		},
		config = function()
			vim.lsp.config('expert', {
			  cmd = { 'expert_darwin_arm64', '--stdio' },
			  cmd_env = {
				GITSTATUS_LOG_LEVEL = 'DEBUG',
			    POWERLEVEL9K_DISABLE_GITSTATUS = 'true',
			  },
			  root_markers = { 'mix.exs', '.git' },
			  filetypes = { 'elixir', 'eelixir', 'heex' },
			});

			vim.lsp.enable('expert');
			vim.lsp.enable('erlangls');
			vim.lsp.config('lua_ls', {
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
			});
			vim.lsp.enable('lua_ls');
		end,
	},
}
