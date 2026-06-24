-- Local-branch review on top of diffview.nvim.
-- Mirrors a GitHub PR review for the changes on the current branch vs a base:
--   :ReviewBranch  -> file-panel summary of your changes vs <base> (like a PR's "Files changed")
--   :ReviewCommits -> per-commit history of your changes vs <base> (step through commits)
-- The base defaults to the repo's real default branch (origin/HEAD); edit it at
-- the prompt to review against any rev (a branch, tag, or sha).

local M = {}

-- The default base to review against. Prefers origin/HEAD (what a PR compares
-- against), so it's correct in repos whose default is master/develop/trunk.
-- Falls back to the first existing common local default branch, then "main".
local function default_base()
	local ref = vim.fn.systemlist({
		"git", "symbolic-ref", "--quiet", "--short", "refs/remotes/origin/HEAD",
	})
	if vim.v.shell_error == 0 and ref[1] and ref[1] ~= "" then
		return ref[1] -- e.g. "origin/main"
	end
	for _, name in ipairs({ "main", "master", "develop", "trunk" }) do
		vim.fn.system({ "git", "rev-parse", "--verify", "--quiet", "refs/heads/" .. name })
		if vim.v.shell_error == 0 then
			return name
		end
	end
	return "main"
end

-- Prompt for the base rev (pre-filled with the detected default), then run fn(base).
local function with_base(prompt, fn)
	vim.ui.input({ prompt = prompt, default = default_base() }, function(base)
		if not base or base == "" then return end
		fn(base)
	end)
end

-- Summary of all your changes vs the base, like a PR's "Files changed" tab.
-- Triple-dot diffs against the merge-base (your changes since you branched);
-- --imply-local keeps the working tree on the right so LSP works in diff buffers.
function M.branch()
	with_base("Review branch vs base: ", function(base)
		vim.cmd("DiffviewOpen " .. base .. "...HEAD --imply-local")
	end)
end

-- Per-commit history of your changes vs the base, to step through individual commits.
function M.commits()
	with_base("Review commits vs base: ", function(base)
		vim.cmd("DiffviewFileHistory --range=" .. base .. "...HEAD --right-only --no-merges")
	end)
end

vim.api.nvim_create_user_command("ReviewBranch", M.branch,
	{ desc = "Review current branch vs a base (diffview file panel)" })
vim.api.nvim_create_user_command("ReviewCommits", M.commits,
	{ desc = "Review current branch's commits vs a base (diffview file history)" })

return M
