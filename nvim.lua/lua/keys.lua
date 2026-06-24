-- unset neovim's new default of Y as y$
vim.keymap.del("n", "Y")

-- disable K (hover) — crashes treesitter highlighting in neovide on stable neovim
-- TODO: re-enable once neovide supports latest treesitter
vim.keymap.set("n", "K", "<Nop>", { noremap = true, silent = true })

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

-- Override built-in grr/gri/grt to populate the location list instead of the quickfix list
vim.keymap.set("n", "grr", function() vim.lsp.buf.references(nil, { loclist = true }) end, { noremap = true, silent = true, desc = "LSP: references (loclist)" })
vim.keymap.set("n", "gri", function() vim.lsp.buf.implementation({ loclist = true }) end, { noremap = true, silent = true, desc = "LSP: implementation (loclist)" })
vim.keymap.set("n", "grt", function() vim.lsp.buf.type_definition({ loclist = true }) end, { noremap = true, silent = true, desc = "LSP: type definition (loclist)" })

-- LSP call hierarchy (via telescope)
vim.keymap.set("n", "grci", function() require('call_hierarchy').incoming() end, { noremap = true, silent = true, desc = "LSP: incoming calls" })
vim.keymap.set("n", "grco", function() require('call_hierarchy').outgoing() end, { noremap = true, silent = true, desc = "LSP: outgoing calls" })

-- Local branch review (diffview) — PR-style review of the current branch vs a base.
-- require registers the :ReviewBranch / :ReviewCommits commands so they're typeable too.
require("review")
vim.keymap.set("n", "<leader>rb", "<cmd>ReviewBranch<CR>", { noremap = true, silent = true, desc = "Review branch vs base (files changed)" })
vim.keymap.set("n", "<leader>rc", "<cmd>ReviewCommits<CR>", { noremap = true, silent = true, desc = "Review branch vs base (per-commit)" })

-- FZF
-- Find files (respects .gitignore — excludes deps/_build)
vim.keymap.set("n", "<C-f>", function()
	require('telescope.builtin').find_files({ prompt_title = "Find files · gitignore respected" })
end, { noremap = true, silent = true, desc = "Find files" })

-- Find files INCLUDING gitignored files (deps, _build, ...)
vim.keymap.set("n", "<leader><C-f>", function()
	require('telescope.builtin').find_files({
		no_ignore = true,
		prompt_title = "Find files · --no-ignore (incl. deps/_build)",
	})
end, { noremap = true, silent = true, desc = "Find files (incl. ignored)" })
vim.keymap.set("n", "<C-b>", function() require('telescope.builtin').buffers({ sort_mru = true }) end, { noremap = true, silent = true })
vim.keymap.set("n", "<C-;>", function() require('telescope.builtin').commands() end, { noremap = true, silent = true })
vim.keymap.set("v", "<C-;>", function() require('telescope.builtin').commands() end, { noremap = true, silent = true })
vim.keymap.set("n", "<D-?>", ":CopilotChat<CR>", { noremap = true, silent = true })

-- handy
vim.keymap.set("n", "\\o", "<cmd>:nohlsearch<CR>", { noremap = true, silent = true })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
vim.keymap.set("n", "-", "<cmd>:e %:h<CR>", { noremap = true, silent = true })

-- Live grep within the files currently in the quickfix list
vim.keymap.set("n", "<leader><C-q>", function()
	local qfiles = vim.fn.getqflist()
	local files = {}
	for _, qf in ipairs(qfiles) do
		-- use the bufnr to get mostly unique
		table.insert(files, vim.fn.bufname(qf.bufnr))
	end
	require('telescope.builtin').live_grep({ search_dirs = files, prompt_title = "Live grep · quickfix files" })
end, { noremap = true, silent = true, desc = "Live grep in quickfix files" })

-- Live grep (respects .gitignore — excludes deps/_build)
vim.keymap.set("n", "<C-g>", function()
	require('telescope.builtin').live_grep({ prompt_title = "Live grep · gitignore respected" })
end, { noremap = true, silent = true, desc = "Live grep" })

-- Live grep INCLUDING gitignored files (deps, _build, ...)
vim.keymap.set("n", "<leader><C-g>", function()
	require('telescope.builtin').live_grep({
		additional_args = { "--no-ignore" },
		prompt_title = "Live grep · --no-ignore (incl. deps/_build)",
	})
end, { noremap = true, silent = true, desc = "Live grep (incl. ignored)" })

-- Live grep scoped to prompted dirs/globs, e.g. "./lib ./deps/*/lib" or "./lib ./test".
-- Explicit paths override .gitignore in ripgrep, so deps paths work without --no-ignore.
vim.keymap.set("n", "<leader>gp", function()
	vim.ui.input({ prompt = "Grep in (space-separated, globs ok): ", default = "./lib ./deps/*/lib" }, function(input)
		if not input or input == "" then return end
		local dirs = {}
		for token in input:gmatch("%S+") do
			local matches = vim.fn.glob(token, false, true) -- expand ./deps/*/lib → real dirs
			if #matches == 0 then
				table.insert(dirs, token)                 -- no match: pass through, rg will report
			else
				vim.list_extend(dirs, matches)
			end
		end
		require('telescope.builtin').live_grep({
			search_dirs = dirs,
			prompt_title = "Live grep · " .. input,       -- show typed tokens, not expanded list
			results_title = #dirs .. " path" .. (#dirs == 1 and "" or "s"),
		})
	end)
end, { noremap = true, silent = true, desc = "Live grep in dirs/globs" })
