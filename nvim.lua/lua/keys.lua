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
keymap("n", "<C-t>p", require("neotest").output_panel.toggle, opts)
keymap("n", "<C-t>w", require("neotest").watch.toggle, opts)
keymap("n", "<C-t>k", function()
	local current_file = vim.fn.expand("%:p")
	local current_line = vim.fn.line('.')
	os.execute(string.format('shtuff into testrunner \"mix test --trace %s:%d\"', current_file, current_line))
	end)
keymap("n", "<C-t>K", require("neotest").jump.prev({ status = "failed" }), opts)
keymap("n", "<C-t>J", require("neotest").jump.next({ status = "failed" }), opts)


-- TODO
-- keymap for mix test --failed
-- nvim-dap + elixir-ls

-- FZF
keymap("n", "<C-f>", "<cmd>:Files<CR>", opts)

-- handy
keymap("n", "\\o", "<cmd>:nohlsearch<CR>", opts)
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", opts)
keymap("n", "-", "<cmd>:e %:h<CR>", opts)

