return {
	{
	  "j-hui/fidget.nvim",
	  opts = {
		-- options
	  },
	},
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
}
