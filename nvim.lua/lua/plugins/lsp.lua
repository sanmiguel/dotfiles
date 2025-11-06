return {
	{
	  "j-hui/fidget.nvim",
	  opts = {
		-- options
	  },
	},
	{
	  "elixir-tools/elixir-tools.nvim",
	  version = "*",
	  event = { "BufReadPre", "BufNewFile" },
	  config = function()
		local elixir = require("elixir")
		local elixirls = require("elixir.elixirls")

		elixir.setup {
		  nextls = {enable = true},
		  elixirls = {
			enable = true,
			settings = elixirls.settings {
			  dialyzerEnabled = false,
			  enableTestLenses = false,
			},
			on_attach = function(client, _bufnr)
			  vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
			  vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
			  vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
			  vim.keymap.set("n", "<leader>lr", require("telescope.builtin").lsp_references, { buffer = true, noremap = true })
			  vim.keymap.set("n", "<leader>ld", require("telescope.builtin").diagnostics, { buffer = true, noremap = true })
			end,
		  },
		  projectionist = {
			enable = true
		  }
		}
	  end,
	  dependencies = {
		"nvim-lua/plenary.nvim",
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
