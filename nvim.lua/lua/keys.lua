local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- unset neovim's new default of Y as y$
vim.keymap.del("n", "Y")

-- neotest
-- TODO Make these only apply for .exs files
keymap("n", "<C-t>t", require("neotest").run.run, opts)
keymap("n", "<C-t>f", function()
	require("neotest").run.run(vim.fn.expand("%"))
end, opts)
keymap("n", "<C-t>s", require("neotest").summary.toggle, opts)
keymap("n", "<C-t>o", require("neotest").output.open, opts)
keymap("n", "<C-t>p", require("neotest").output_panel.toggle, opts)
keymap("n", "<C-t>w", require("neotest").watch.toggle, opts)
keymap("n", "<C-t>k", function()
	local current_file = vim.fn.expand("%:p")
	local current_line = vim.fn.line('.')
	os.execute(string.format('shtuff into testrunner \"mix test --trace %s:%d\"', current_file, current_line))
	end)
-- keymap("n", "<C-t>K", function() require("neotest").jump.prev({ status = "failed" }) end, opts)
-- keymap("n", "<C-t>J", function() require("neotest").jump.next({ status = "failed" }) end, opts)


-- TODO
-- keymap for mix test --failed
-- nvim-dap + elixir-ls

-- FZF
keymap("n", "<C-f>", function() require('telescope.builtin').find_files({ ignore = false }) end, opts)

-- handy
keymap("n", "\\o", "<cmd>:nohlsearch<CR>", opts)
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", opts)
keymap("n", "-", "<cmd>:e %:h<CR>", opts)

vim.keymap.set("n", "<leader><C-f>", function()
	local qfiles = vim.fn.getqflist()
	local files = {}
	for _, qf in ipairs(qfiles) do
		-- use the bufnr to get mostly unique
		table.insert(files, vim.fn.bufname(qf.bufnr))
	end
	require('telescope.builtin').live_grep({ search_dirs = files })
end, { noremap = true, silent = true })
