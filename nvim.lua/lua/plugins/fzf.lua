return {
	{
		dir = "/opt/homebrew/opt/fzf",
		lazy = false,
		init = function()
		end
	},
	"junegunn/fzf.vim",
	{
		"ibhagwan/fzf-lua",
		config = function()
			require("fzf-lua").setup({ "fzf-vim" })
		end,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		}
	},
	{
		'dominickng/fzf-session.vim',
		config = function()
			vim.g.fzf_session_path = vim.fn.stdpath("data") .. '/session'
			local kmopts = { noremap = true, silent = true }
			vim.keymap.set("n", "<C-s><C-s>", "<cmd>:Sessions<CR>", kmopts)
		end,
		dependencies = {
			"junegunn/fzf.vim"
		}
	},
}
