return {
	"tpope/vim-rsi",
	"itchyny/vim-qfedit",
	-- {
	-- 	"iCyMind/NeoSolarized",
	-- 	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	-- 	priority = 1000, -- make sure to load this before all the other start plugins
	-- 	config = function()
	-- 		-- load the colorscheme here
	-- 		-- vim.cmd.colorscheme([[NeoSolarized]])
	-- 	end,
	-- 	init = function()
	-- 		vim.g.neosolarized_italic = 1
	-- 		vim.g.neosolarized_termtrans = 1
	-- 		vim.g.neosolarized_contrast = "high"
	-- 		vim.g.neosolarized_diffmode = "high"
	-- 	end,
	-- },
	{
		"Tsuzat/NeoSolarized.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		init = function()
			local ok_status, NeoSolarized = pcall(require, "NeoSolarized")

			if not ok_status then
				return
			end

			-- Default Setting for NeoSolarized

			NeoSolarized.setup {
				-- style = "dark", -- "dark" or "light"
				transparent = false, -- true/false; Enable this to disable setting the background color
				-- terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
				-- enable_italics = true, -- Italics for different hightlight groups (eg. Statement, Condition, Comment, Include, etc.)
				styles = {
				-- 	-- Style to be applied to different syntax groups
				-- 	comments = { italic = true },
				-- 	keywords = { italic = true },
					functions = { bold = false },
				-- 	variables = {},
				-- 	string = { italic = true },
				-- 	underline = true, -- true/false; for global underline
				-- 	undercurl = true, -- true/false; for global undercurl
				},
				-- Add specific hightlight groups
				on_highlights = function(highlights, colors)
					highlights.Function.fg = colors.blue
					-- highlights.Include.fg = colors.red -- Using `red` foreground for Includes
				end,
			}
			-- Set colorscheme to NeoSolarized
			vim.cmd [[
				try
					colorscheme NeoSolarized
				catch /^Vim\%((\a\+)\)\=:E18/
					colorscheme default
					set background=dark
				endtry
			]]
		end,
		config = function()
			-- vim.cmd [[ colorscheme NeoSolarized ]]
		end
	},
	-- {
	--   "tjdevries/colorbuddy.nvim",
	-- },
	-- {
	-- 	"svrana/neosolarized.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	dependencies = {
	-- 		"tjdevries/colorbuddy.nvim",
	-- 	},
	-- 	config = function()
	-- 		n = require('neosolarized').setup({
	-- 			comment_italics = true,
	-- 			background_set = true,
	-- 		})
	-- 		vim.cmd.colorscheme("neosolarized")
	-- 	end,
	-- 	init = function()
	-- 	end,
	-- },
	-- {
	-- 	"folke/which-key.nvim",
	-- 	event = "VeryLazy",
	-- 	init = function()
	-- 		vim.o.timeout = true
	-- 		vim.o.timeoutlen = 300
	-- 	end,
	-- 	opts = {
	-- 		-- your configuration comes here
	-- 		-- or leave it empty to use the default settings
	-- 		-- refer to the configuration section below
	-- 	}
	-- },
	{
		"f-person/auto-dark-mode.nvim",
		config = function()
			require('auto-dark-mode').setup({
				update_interval = 1000,
				set_dark_mode = function()
					vim.o.background = 'dark'
				end,
				set_light_mode = function()
					vim.o.background = 'light'
				end,
			})
		end,
	},
	-- {
	--     "vim-airline/vim-airline",
	--     init = function()
	--         vim.g.airline_powerline_fonts = 1
	--         vim.g.airline_left_sep = ''
	--         vim.g.airline_right_sep = ''
	--         vim.g.airline_section_b = ''
	--         vim.g.airline_theme = 'sanmiguelito'
	--     end,
	-- },
	{
		'nvim-lualine/lualine.nvim',
		config = function()
			require("lualine").setup({
				options = {
					-- component_separators = { left = '', right = '' },
					component_separators = { left = '', right = '' },
					--     
					section_separators = { left = '', right = '' },
					theme = "solarized_dark",
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "filename" },
					lualine_c = {
					},
				}
			})
		end,
		dependencies = {
			'nvim-tree/nvim-web-devicons',
		}
	},
	"tpope/vim-unimpaired",
	{
		"tpope/vim-surround",
		config = function()
			vim.g.surround_101 = "{:error, \r}" -- yse
			vim.g.surround_111 = "{:ok, \r}" -- yso
			vim.g.surround_110 = "{:noreply, \r}" -- ysn
			vim.g.surround_114 = "{:reply, \1reply: \1, \2state: \2\r}"
			vim.g.surround_37 = "%{\r: }" -- ys%
			vim.g.surround_53 = "%{\"\r\" => }" -- ys5
			vim.g.surround_58 = "\r:" --  ys:
			vim.g.surround_59 = ":\r" -- ys;
			vim.g.surround_124 = "|> \r" -- ys|
			vim.g.surround_107 = ".\r" -- ysk
		end
	},
	"tpope/vim-commentary",
}
