return {
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.6',
		-- or                          , branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{
	  "ahmedkhalf/project.nvim",
	  config = function()
		require("project_nvim").setup {
		  -- your configuration comes here
		  -- or leave it empty to use the default settings
		  -- refer to the configuration section below
		}
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
		"zk-org/zk-nvim",
		config = function()
			require("zk").setup({
				picker = "telescope"
				-- See Setup section below
			})
		end
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" }
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
		  auto_session_suppress_dirs = { "~/", "~/git", "~/Documents", "~/Downloads", "/"},
		  auto_session_use_git_branch = true,
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
		-- after = "telescope.nvim",
		event = "VimEnter",
		config = function()
			require('bookmarks').setup()
		end
	}
}
