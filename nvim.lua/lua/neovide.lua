if vim.g.neovide then
	vim.g.neovide_font_default_size = 16
	vim.g.neovide_font_size_delta = 0
	vim.g.neovide_font_family = 'Hasklug Nerd Font Mono'

	vim.o.guifont = vim.g.neovide_font_family .. ':h' .. vim.g.neovide_font_default_size

	local set_font = function(family, size)
		vim.o.guifont = family .. ':h' .. size
	end

	local resize_font = function(delta)
		vim.g.neovide_font_size_delta = vim.g.neovide_font_size_delta + delta
		set_font(vim.g.neovide_font_family, vim.g.neovide_font_default_size + vim.g.neovide_font_size_delta)
	end

	local inc_font = function()
		resize_font(1)
	end
	local dec_font = function()
		resize_font(-1)
	end
	local reset_font = function()
		set_font(vim.g.neovide_font_family, vim.g.neovide_font_default_size)
	end

	local kmopts = { noremap = true, silent = true }

	vim.keymap.set("n", "<D-->", dec_font, kmopts)
	vim.keymap.set("n", "<D-0>", reset_font, kmopts)

	vim.keymap.set({"n", "v"}, "<D-c>", '"+y', kmopts)
	vim.keymap.set("n", "<D-v>", '"+p', kmopts)
	vim.keymap.set({"i", "c", "t"}, "<D-v>", '<C-r>+', kmopts)

	vim.keymap.set({"n", "v", "i", "c", "t"}, "<D-n>", "!neovide --fork &<CR>", kmopts)
	vim.keymap.set({"n", "v", "i", "c", "t"}, "<D-,>", "!cd ~/.config/nvim && neovide --fork &<CR>", kmopts)
	vim.diagnostic.config({
	  virtual_text = false, -- Disable virtual text
	  signs = true, -- Enable signs
	  update_in_insert = false, -- Update diagnostics in insert mode
	  underline = true, -- Enable underline
	  severity_sort = true, -- Sort diagnostics by severity
	  float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	  },
	})
	-- Show diagnostics in a popover preview window on cursor move with a delay
	vim.api.nvim_create_autocmd("CursorMoved", {
	  callback = function()
		vim.defer_fn(function()
		  local opts = {
			focusable = false,
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			border = 'rounded',
			source = 'always',
			prefix = ' ',
			scope = 'cursor',
		  }
		  vim.diagnostic.open_float(nil, opts)
		end, 300) -- 300ms delay
	  end
	})
end
