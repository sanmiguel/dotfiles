return {
	{
	  "j-hui/fidget.nvim",
	  opts = {
		-- options
	  },
	},
  -- {
	  -- "linrongbin16/lsp-progress.nvim",
	  -- config = function()
		  -- require("lsp-progress").setup({
			  -- decay = 1200,
			  -- series_format = function(title, message, percentage, done)
				  -- local builder = {}
				  -- local has_title = false
				  -- local has_message = false
				  -- if type(title) == "string" and string.len(title) > 0 then
					  -- local escaped_title = title:gsub("%%", "%%%%")
					  -- table.insert(builder, escaped_title)
					  -- has_title = true
				  -- end
				  -- if type(message) == "string" and string.len(message) > 0 then
					  -- local escaped_message = message:gsub("%%", "%%%%")
					  -- table.insert(builder, escaped_message)
					  -- has_message = true
				  -- end
				  -- if percentage and (has_title or has_message) then
					  -- table.insert(builder, string.format("(%.0f%%%%)", percentage))
				  -- end
				  -- return { msg = table.concat(builder, " "), done = done }
			  -- end,
			  -- client_format = function(client_name, spinner, series_messages)
				  -- if #series_messages == 0 then
					  -- return nil
				  -- end
				  -- local builder = {}
				  -- local done = true
				  -- for _, series in ipairs(series_messages) do
					  -- if not series.done then
						  -- done = false
					  -- end
					  -- table.insert(builder, series.msg)
				  -- end
				  -- if done then
					  -- spinner = "✓" -- replace your check mark
				  -- end
				  -- return "["
				  -- .. client_name
				  -- .. "] "
				  -- .. spinner
				  -- .. " "
				  -- .. table.concat(builder, ", ")
			  -- end,
		  -- })
	  -- end,
  -- },
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
		  -- require'lspconfig'.elixirls.setup{
			  -- -- on_attach = custom_attach, -- this may be required for extended functionalities of the LSP
			  -- -- capabilities = capabilities,
			  -- flags = {
				  -- debounce_text_changes = 150,
			  -- },
			  -- elixirLS = {
				  -- dialyzerEnabled = false,
				  -- fetchDeps = true,
			  -- };
		  -- }
		  local on_attach = function(_, bufnr)
		    local opts = { noremap=true, silent=true }

		    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
		    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
		    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
		    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
		    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
		    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
		    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
		    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
		    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
		    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cd', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
		    vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
		    vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
		  end
		  require'lspconfig'.nextls.setup{
			  cmd = { "/opt/homebrew/opt/next-ls/bin/nextls", "--stdio" },
			  on_attach = on_attach,
			  init_options = {
				extensions = {
				  credo = { enable = true }
				},
				experimental = {
				  completions = { enable = true }
				}
			  }
		  }
	  end,
  },
}
