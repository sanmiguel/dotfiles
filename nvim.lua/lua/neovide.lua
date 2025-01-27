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
end
