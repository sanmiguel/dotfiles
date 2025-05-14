return {
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.8',
		-- or                          , branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			vim.keymap.set("n", "<C-t><C-t>", "Telescope<CR>", { noremap = true })
			require("telescope").setup({
			  layout_strategy = 'vertical',
			  layout_config = {
				height = 0.95, -- take up most of the screen height
				width = 0.95,  -- take up most of the screen width
				preview_height = 0.6, -- preview window takes 60% of the total height
				prompt_position = "top" -- put prompt at the top
			  },
			  defaults = {
				mappings = {
				  i = {
					["<C-q>"] = require("telescope.actions").smart_add_to_qflist + require("telescope.actions").open_qflist,
				  }
				}
			  },
			  pickers = {
				buffers = {
				  layout_strategy = 'vertical',
				  layout_config = {
					height = 0.75, -- take up most of the screen height
					width = 0.85,  -- take up most of the screen width
					preview_height = 0.6, -- preview window takes 60% of the total height
					prompt_position = "bottom" -- put prompt at the top
				  },
				},
				find_files = {
				  layout_strategy = 'vertical',
				  layout_config = {
					height = 0.75, -- take up most of the screen height
					width = 0.85,  -- take up most of the screen width
					preview_height = 0.6, -- preview window takes 60% of the total height
					prompt_position = "bottom" -- put prompt at the top
				  },
				}
			  }
			})
		end
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			-- This is your opts table
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown {
							-- even more opts
						}

						-- pseudo code / specification for writing custom displays, like the one
						-- for "codeactions"
						-- specific_opts = {
						--   [kind] = {
						--     make_indexed = function(items) -> indexed_items, width,
						--     make_displayer = function(widths) -> displayer
						--     make_display = function(displayer) -> function(e)
						--     make_ordinal = function(e) -> string
						--   },
						--   -- for example to disable the custom builtin "codeactions" display
						--      do the following
						--   codeactions = false,
						-- }
					}
				}
			})
			-- To get ui-select loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("ui-select")
			-- local wk = require("which-key")
			-- wk.register({
			-- 	g = {
			-- 		name = "+Git",
			-- 		h = {
			-- 			name = "+Github",
			-- 			c = {
			-- 				name = "+Commits",
			-- 				c = { "<cmd>GHCloseCommit<cr>", "Close" },
			-- 				e = { "<cmd>GHExpandCommit<cr>", "Expand" },
			-- 				o = { "<cmd>GHOpenToCommit<cr>", "Open To" },
			-- 				p = { "<cmd>GHPopOutCommit<cr>", "Pop Out" },
			-- 				z = { "<cmd>GHCollapseCommit<cr>", "Collapse" },
			-- 			},
			-- 			i = {
			-- 				name = "+Issues",
			-- 				p = { "<cmd>GHPreviewIssue<cr>", "Preview" },
			-- 			},
			-- 			l = {
			-- 				name = "+Litee",
			-- 				t = { "<cmd>LTPanel<cr>", "Toggle Panel" },
			-- 			},
			-- 			r = {
			-- 				name = "+Review",
			-- 				b = { "<cmd>GHStartReview<cr>", "Begin" },
			-- 				c = { "<cmd>GHCloseReview<cr>", "Close" },
			-- 				d = { "<cmd>GHDeleteReview<cr>", "Delete" },
			-- 				e = { "<cmd>GHExpandReview<cr>", "Expand" },
			-- 				s = { "<cmd>GHSubmitReview<cr>", "Submit" },
			-- 				z = { "<cmd>GHCollapseReview<cr>", "Collapse" },
			-- 			},
			-- 			p = {
			-- 				name = "+Pull Request",
			-- 				c = { "<cmd>GHClosePR<cr>", "Close" },
			-- 				d = { "<cmd>GHPRDetails<cr>", "Details" },
			-- 				e = { "<cmd>GHExpandPR<cr>", "Expand" },
			-- 				o = { "<cmd>GHOpenPR<cr>", "Open" },
			-- 				p = { "<cmd>GHPopOutPR<cr>", "PopOut" },
			-- 				r = { "<cmd>GHRefreshPR<cr>", "Refresh" },
			-- 				t = { "<cmd>GHOpenToPR<cr>", "Open To" },
			-- 				z = { "<cmd>GHCollapsePR<cr>", "Collapse" },
			-- 			},
			-- 			t = {
			-- 				name = "+Threads",
			-- 				c = { "<cmd>GHCreateThread<cr>", "Create" },
			-- 				n = { "<cmd>GHNextThread<cr>", "Next" },
			-- 				t = { "<cmd>GHToggleThread<cr>", "Toggle" },
			-- 			},
			-- 		},
			-- 	},
			-- }, { prefix = "<leader>" })
		end
	},
	{
		"ThePrimeagen/git-worktree.nvim",
		config = function()
			require("git-worktree").setup({
				-- change_directory_command = <str> -- default: "cd",
				-- update_on_change = <boolean> -- default: true,
				-- update_on_change_command = <str> -- default: "e .",
				-- clearjumps_on_change = <boolean> -- default: true,
				-- autopush = <boolean> -- default: false,
			})
		end
	},
	{
	  'rmagatti/auto-session',
	  config = function()
		require("auto-session").setup {
		  log_level = "error",
		  show_auto_restore_notif = true,
		  lsp_stop_on_restore = true,
		  close_unsupported_windows = true,
		  suppressed_dirs = { "~/", "~/git", "~/dotfiles", "~/Documents", "~/Downloads", "/"},
		  use_git_branch = true,
		}
	  end
	},
	{
		'rmagatti/session-lens',
		requires = {'rmagatti/auto-session', 'nvim-telescope/telescope.nvim'},
		config = function()
			require('session-lens').setup({--[[your custom config--]]})
			require("telescope").load_extension("session-lens")
		end
	},
	{
		'tomasky/bookmarks.nvim',
		requires = {'nvim-telescope/telescope.nvim'},
		event = "VimEnter",
		config = function()
			require('bookmarks').setup({
				save_file = vim.fn.expand "./.bookmarks",
				keywords =  {
					["@t"] = "☑️ ", -- mark annotation startswith @t ,signs this icon as `Todo`
					["@w"] = "⚠️ ", -- mark annotation startswith @w ,signs this icon as `Warn`
					["@f"] = "⛏ ", -- mark annotation startswith @f ,signs this icon as `Fix`
					["@n"] = " ", -- mark annotation startswith @n ,signs this icon as `Note`
				},
				on_attach = function(_)
					local bm = require "bookmarks"
					local map = vim.keymap.set
					map("n","<leader>mm",bm.bookmark_toggle) -- add or remove bookmark at current line
					map("n","<leader>mi",bm.bookmark_ann) -- add or edit mark annotation at current line
					map("n","<leader>mc",bm.bookmark_clean) -- clean all marks in local buffer
					map("n","<leader>mn",bm.bookmark_next) -- jump to next mark in local buffer
					map("n","<leader>mp",bm.bookmark_prev) -- jump to previous mark in local buffer
					map("n","<leader>ml",require('telescope').extensions.bookmarks.list) -- show marked file list in quickfix window
				end
			})
			require('telescope').load_extension('bookmarks')
		end
	}
}
