-- unset neovim's new default of Y as y$
vim.keymap.del("n", "Y")

-- neotest
-- TODO Make these only apply for .exs files
vim.keymap.set("n", "<C-t>t", require("neotest").run.run, { noremap = true, silent = true })
vim.keymap.set("n", "<C-t>f", function()
	require("neotest").run.run(vim.fn.expand("%"))
end, { noremap = true, silent = true })
vim.keymap.set("n", "<C-t>s", require("neotest").summary.toggle, { noremap = true, silent = true })
vim.keymap.set("n", "<C-t>o", require("neotest").output.open, { noremap = true, silent = true })
vim.keymap.set("n", "<C-t>p", require("neotest").output_panel.toggle, { noremap = true, silent = true })
vim.keymap.set("n", "<C-t>w", require("neotest").watch.toggle, { noremap = true, silent = true })
vim.keymap.set("n", "<C-t>c", function() require("coverage").load(true) end, { noremap = true, silent = true })
vim.keymap.set("n", "<C-t>C", function() require("coverage").load(true); require("coverage").summary() end, { noremap = true, silent = true })
vim.keymap.set("n", "<C-t>k", function()
	local current_file = vim.fn.expand("%:p")
	local current_line = vim.fn.line('.')
	local testrunner = vim.env.TESTRUNNER or 'testrunner'
	-- TODO FIXME handle testrunner being unset and warn that nothing was found
	os.execute(string.format('shtuff into %s \"iex -S mix test --trace %s:%d\"', testrunner, current_file, current_line))
	end)
-- vim.keymap.set("n", "<C-t>K", function() require("neotest").jump.prev({ status = "failed" }) end, { noremap = true, silent = true })
-- vim.keymap.set("n", "<C-t>J", function() require("neotest").jump.next({ status = "failed" }) end, { noremap = true, silent = true })


-- TODO
-- keymap for mix test --failed
-- nvim-dap + elixir-ls

-- FZF
vim.keymap.set("n", "<C-f>", function() require('telescope.builtin').find_files({ ignore = false }) end, { noremap = true, silent = true })
vim.keymap.set("n", "<C-b>", function() require('telescope.builtin').buffers({ sort_mru = true }) end, { noremap = true, silent = true })
vim.keymap.set("n", "<C-;>", function() require('telescope.builtin').commands() end, { noremap = true, silent = true })
vim.keymap.set("v", "<C-;>", function() require('telescope.builtin').commands() end, { noremap = true, silent = true })
vim.keymap.set("n", "<D-?>", ":CopilotChat<CR>", { noremap = true, silent = true })

-- handy
vim.keymap.set("n", "\\o", "<cmd>:nohlsearch<CR>", { noremap = true, silent = true })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
vim.keymap.set("n", "-", "<cmd>:e %:h<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader><C-f>", function()
	local qfiles = vim.fn.getqflist()
	local files = {}
	for _, qf in ipairs(qfiles) do
		-- use the bufnr to get mostly unique
		table.insert(files, vim.fn.bufname(qf.bufnr))
	end
	require('telescope.builtin').live_grep({ search_dirs = files })
end, { noremap = true, silent = true })
