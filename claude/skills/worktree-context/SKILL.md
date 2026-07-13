---
name: worktree-context
description: >-
  Save or restore a worktree/branch's context doc — key decisions, rejected
  approaches / dead-ends, and open threads — as a git note on the branch's
  first commit. Use "save" after opening a PR from a worktree so a later
  session can resume with full reasoning; use "resume" when returning to a
  branch that has a saved note (the SessionStart hook announces it).
---

# worktree-context

Persists the *reasoning* behind a branch — not the code — so a future session
(e.g. one opened to address PR feedback after the original session is gone) can
pick up where this one left off. The doc is stored as a git note on the
branch's first commit: a stable, branch-unique anchor that survives amend/rebase
via `notes.rewriteRef`. Notes are local to this machine (never pushed).

Helper script (also invoked by the SessionStart hook):
`/Users/sanmiguel/dotfiles/claude/skills/worktree-context/worktree-context.sh`

## Mode: save

Run after the PR for the current branch exists.

1. Write `.worktree-context.md` at the repo root, concisely:
   - **Goal** — what this branch set out to do (1–2 lines).
   - **Key decisions** — choices made and *why* — the non-obvious ones.
   - **Dead-ends** — approaches tried that didn't work, and why, so they aren't
     re-attempted.
   - **Open threads** — anything unfinished or likely to surface in review.

   Keep it tight — a memory aid, not documentation.
2. Store it as the branch's note:
   ```bash
   bash /Users/sanmiguel/dotfiles/claude/skills/worktree-context/worktree-context.sh save .worktree-context.md
   ```
3. Report the anchor commit. `.worktree-context.md` is gitignored, so it never
   enters the PR.

## Mode: resume

Run when returning to a branch that has a saved note (the SessionStart hook
announces it).

1. Materialize the note:
   ```bash
   bash /Users/sanmiguel/dotfiles/claude/skills/worktree-context/worktree-context.sh resume
   ```
2. Read the printed `.worktree-context.md` into context before continuing.
3. To update the record after more work, edit the file and re-run `save` — it
   overwrites the branch's existing note.
