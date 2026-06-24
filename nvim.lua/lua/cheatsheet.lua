-- Floating cheatsheet of the custom keymaps/commands we've added to this config.
-- Open with <leader>? or :Cheatsheet. Dismiss with q or <Esc>.
-- Hand-curated (not a dump of every mapping) — keep it in sync as bindings change.

local M = {}

-- { title, items = { { keys, description }, ... } }
local sections = {
	{
		title = "Branch review  (diffview)",
		items = {
			{ "<leader>rb", ":ReviewBranch  — files changed vs base" },
			{ "<leader>rc", ":ReviewCommits — per-commit vs base" },
			{ "<tab> / <s-tab>", "next / prev file (inside diff view)" },
			{ "g?", "diffview's own keymap help" },
			{ ":DiffviewClose", "exit the review" },
		},
	},
	{
		title = "LSP lists  (→ location list)",
		items = {
			{ "grr", "references" },
			{ "gri", "implementation" },
			{ "grt", "type definition" },
			{ "grci / grco", "incoming / outgoing calls" },
			{ ":lopen  ]l  [l", "open loclist / next / prev (unimpaired)" },
		},
	},
	{
		title = "Find files  (telescope)",
		items = {
			{ "<C-f>", "find files (respects .gitignore)" },
			{ "<leader><C-f>", "find files incl. ignored (deps/_build)" },
			{ "<C-b>", "buffers (recent first)" },
		},
	},
	{
		title = "Live grep  (telescope)",
		items = {
			{ "<C-g>", "grep (respects .gitignore)" },
			{ "<leader><C-g>", "grep incl. ignored (deps/_build)" },
			{ "<leader>gp", "grep in prompted dirs/globs" },
			{ "<leader><C-q>", "grep within quickfix files" },
		},
	},
	{
		title = "GitHub PRs  (gh.nvim)",
		items = {
			{ ":GHOpenPR", "open a PR from GitHub" },
		},
	},
}

local ns = vim.api.nvim_create_namespace("cheatsheet")

-- Build the rendered lines plus single-line highlight marks { row, col, end_col, hl }.
local function render()
	local lines, marks = {}, {}
	local key_w = 0
	for _, s in ipairs(sections) do
		for _, it in ipairs(s.items) do
			key_w = math.max(key_w, #it[1])
		end
	end
	local function add(line)
		table.insert(lines, line)
		return #lines - 1 -- 0-based row of the line just added
	end
	for i, s in ipairs(sections) do
		if i > 1 then add("") end
		local title = "  " .. s.title
		table.insert(marks, { add(title), 0, #title, "Title" })
		for _, it in ipairs(s.items) do
			local line = string.format("    %-" .. key_w .. "s   %s", it[1], it[2])
			table.insert(marks, { add(line), 4, 4 + #it[1], "Special" })
		end
	end
	return lines, marks
end

function M.open()
	local lines, marks = render()

	local width = 0
	for _, l in ipairs(lines) do
		width = math.max(width, vim.fn.strdisplaywidth(l))
	end
	width = width + 2
	local height = #lines

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	for _, m in ipairs(marks) do
		vim.api.nvim_buf_set_extmark(buf, ns, m[1], m[2], { end_col = m[3], hl_group = m[4] })
	end
	vim.bo[buf].modifiable = false
	vim.bo[buf].bufhidden = "wipe"

	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2 - 1),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
		title = " custom keymaps ",
		title_pos = "center",
		footer = " q / <Esc> to close ",
		footer_pos = "center",
	})

	for _, k in ipairs({ "q", "<Esc>" }) do
		vim.keymap.set("n", k, "<cmd>close<CR>", { buffer = buf, nowait = true, silent = true })
	end
end

vim.api.nvim_create_user_command("Cheatsheet", M.open,
	{ desc = "Show the custom keymaps/commands cheatsheet" })

return M
