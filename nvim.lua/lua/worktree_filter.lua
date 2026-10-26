-- Drop `.claude/worktrees` copies from go-to-definition (<C-]> / g] / :tjump).
--
-- WHY THIS EXISTS
-- <C-]> is driven by `tagfunc`, which Neovim points at `vim.lsp.tagfunc`; that
-- merges textDocument/definition from every attached LSP server. Our Dexter
-- server indexes *every* .ex/.exs under the repo root, ignoring .gitignore, so
-- it also indexes the copies Claude Code leaves in
-- <repo>/.claude/worktrees/<branch>/. Result: go-to-definition offers duplicate
-- hits inside those worktrees instead of ./lib.
--
-- Dexter has no per-path ignore setting, so we filter client-side here: wrap
-- vim.lsp.tagfunc and drop any result under .claude/worktrees. Skipped when the
-- current file is itself inside a worktree, so navigating within one still works.
--
-- TO REMOVE (e.g. once Dexter can exclude the path itself): delete this file,
-- the `require("worktree_filter")` line in lua/keys.lua, and swap the grr/gri/grt
-- `on_list = worktree_filter.on_list` back to `loclist = true`. Nothing else
-- depends on it — it only wraps a stdlib function and restores cleanly on the
-- next Neovim start.

local WORKTREE = "/%.claude/worktrees/" -- Lua pattern; %. is a literal dot

local function in_worktree(path)
	return path ~= nil and path:find(WORKTREE) ~= nil
end

-- Capture the real tagfunc once, so re-sourcing this file never wraps a wrapper.
if not vim.lsp._worktree_filter_orig_tagfunc then
	vim.lsp._worktree_filter_orig_tagfunc = vim.lsp.tagfunc
end
local orig_tagfunc = vim.lsp._worktree_filter_orig_tagfunc

vim.lsp.tagfunc = function(...)
	local tags = orig_tagfunc(...)
	if type(tags) ~= "table" then
		return tags
	end
	-- Editing inside a worktree: keep everything so local navigation works.
	if in_worktree(vim.api.nvim_buf_get_name(0)) then
		return tags
	end
	local kept = vim.tbl_filter(function(tag)
		return not in_worktree(tag.filename)
	end, tags)
	-- If the only matches were in a worktree, fall back to the unfiltered list
	-- so go-to-definition never silently comes up empty.
	if #kept == 0 then
		return tags
	end
	return kept
end

-- Same filtering for the LSP list commands (grr / gri / grt in lua/keys.lua).
-- setloclist() fires no autocommand, so instead of cleaning the list after it
-- loads we pass this as `on_list`, which receives the items before they're set.
local M = {}

-- Expert and Dexter both answer, so a reference can arrive twice: once as a
-- range ("col 36-53", or multi-line "89-93 col 14-15") and once as a bare line
-- hit ("col 1").
local function has_range(item)
	local end_lnum = item.end_lnum or 0
	if end_lnum > item.lnum then
		return true
	end
	return end_lnum == item.lnum and (item.end_col or 0) > item.col
end

local function is_bare_line_hit(item)
	return item.col == 1 and not has_range(item)
end

-- Drop a bare line hit when another, more specific entry starts on the same
-- line. Several specific entries on one line are all kept.
local function drop_bare_line_duplicates(items)
	local lines_with_specific_hits = {}
	for _, item in ipairs(items) do
		if not is_bare_line_hit(item) then
			lines_with_specific_hits[item.filename .. ":" .. item.lnum] = true
		end
	end
	return vim.tbl_filter(function(item)
		return not (is_bare_line_hit(item) and lines_with_specific_hits[item.filename .. ":" .. item.lnum])
	end, items)
end

function M.on_list(result)
	local items = result.items
	if not in_worktree(vim.api.nvim_buf_get_name(0)) then
		local kept = vim.tbl_filter(function(item)
			return not in_worktree(item.filename)
		end, items)
		if #kept > 0 then
			items = kept
		end
	end
	items = drop_bare_line_duplicates(items)
	-- Sort by file, then position within the file.
	table.sort(items, function(a, b)
		if a.filename ~= b.filename then
			return a.filename < b.filename
		end
		if a.lnum ~= b.lnum then
			return a.lnum < b.lnum
		end
		return a.col < b.col
	end)
	vim.fn.setloclist(0, {}, " ", { title = result.title, items = items, context = result.context })
	vim.cmd("lopen")
end

return M
