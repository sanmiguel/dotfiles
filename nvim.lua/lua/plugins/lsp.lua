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
			  cmd = { '/Users/sanmiguel/git/elixir-lang/expert/apps/expert/_build/prod/rel/plain/bin/start_expert', '--stdio' },
			  cmd_env = {
				GITSTATUS_LOG_LEVEL = 'DEBUG',
			    POWERLEVEL9K_DISABLE_GITSTATUS = 'true',
			  },
			  root_markers = { 'mix.exs', '.git' },
			  filetypes = { 'elixir', 'eelixir', 'heex' },
			});

			vim.lsp.enable('expert');

			-- Dexter panics on non-file:// URIs (e.g. fugitive://) in didOpen,
			-- which crashes the whole server. Gate attachment to real files.
			-- Upstream bug: dexter internal/lsp/server.go:452 (DidOpen).
			local dexter_config = {
			  name = 'dexter',
			  cmd = { 'dexter', 'lsp' },
			  root_markers = { '.dexter.db', 'mix.exs', '.git' },
			  filetypes = { 'elixir', 'eelixir', 'heex' },
			  init_options = {
				followDelegates = true,
			  },
			};
			vim.api.nvim_create_autocmd('FileType', {
			  pattern = { 'elixir', 'eelixir', 'heex' },
			  callback = function(args)
				local name = vim.api.nvim_buf_get_name(args.buf)
				if name == '' or (name:match('^%w+://') and not name:match('^file://')) then
				  return
				end
				local root = vim.fs.root(args.buf, dexter_config.root_markers)
				if not root then return end
				vim.lsp.start(vim.tbl_extend('force', dexter_config, { root_dir = root }), { bufnr = args.buf })
			  end,
			});

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
