---
name: obsidian-vault
description: >-
  Write personal engineering notes (PR reviews, investigation / debugging
  write-ups, session hand-off notes) into the local HOPCo Obsidian vault instead
  of the repo, following the vault's folder, filename and frontmatter
  conventions, and search or update the notes already there. Use when asked to
  "put this in Obsidian", "save this review", "note this in the vault", or
  "what did I note about X".
---

## Where the vault is

- Root: `~/Documents/Obsidian/HOPCo/HOPCo` (the folder that contains `.obsidian/`).
  The parent `~/Documents/Obsidian/HOPCo/` is NOT the vault: never write there
  and never create a second `.obsidian/`.
- Obsidian picks up files as soon as they land on disk; there is no reload step.
- Core plugins only: no Templater or Dataview syntax.

## What belongs here, and what does not

Write to the vault:
- PR reviews (`type: pr-review`)
- Investigation / debugging write-ups (`type: investigation`)
- Session hand-off notes (`type: session-note`) for context that does not belong
  on a branch; branch-scoped hand-off stays with the `worktree-context` skill.

Stays in the repo (usually `docs/`), never redirect it here: README, design docs,
plans and proposals, runbooks, API references, anything the team relies on or
that ships with the code. If "write this up" is ambiguous, ask: personal note
(vault) or team document (repo)?

## Layout

- One folder per repository, created on demand: `<vault>/<repo>/`. `<repo>` is
  the repository name from the origin remote, NOT the working-directory name
  (worktrees are called `main`, `proto`, ...):

  ```bash
  basename -s .git "$(git remote get-url origin)"
  ```

  No remote: ask which folder to use. Cross-project notes go in the vault root.
- Filenames are kebab-case with a type prefix; slugs are lowercase, at most six
  words, and carry no date except in session notes:
  - `pr-<number>-review.md`
  - `investigation-<slug>.md`
  - `session-<YYYY-MM-DD>-<slug>.md`

## Frontmatter

Every new note starts with exactly these properties:

```yaml
---
type: pr-review                     # pr-review | investigation | session-note
project: scheduling-intelligence    # same as the folder name
created: 2026-09-14                 # ISO date, unquoted
tags: [scheduling-intelligence, pr-review]
repo: https://github.com/<org>/<repo>
pr: https://github.com/<org>/<repo>/pull/212   # pr-review only
branch: feature-branch-name                     # only when relevant
---
```

Rules: valid YAML; `tags` is a flat list, lowercase, hyphens only, no `#` and
no spaces; omit a key rather than leave it empty; derive `repo` from the origin
URL (`git@host:org/repo.git` becomes `https://host/org/repo`, keep the host).

## Note templates

PR review (matches the existing `scheduling-intelligence/pr-*-review.md` notes):

```markdown
# PR #<N> — <PR title>

- **Author:** <author>
- **Branch:** `<head>` → `<base>`
- **Files:** <n> changed (+<added>/−<deleted>)
- **Prior feedback:** <existing reviews / bot findings, or "none">
- **Status of this review:** LOCAL ONLY — not posted to GitHub

## Overview
<what the PR does, one to three short paragraphs>

## Findings
### 1. <title> (<high | medium | low | nit>)
<evidence as `path/file.ex:line`, why it matters, suggested fix>

## What's good

## Verdict
<merge / request changes / needs discussion, one paragraph>
```

Order findings by severity. Once the review is posted to GitHub, change the
status line to `posted <YYYY-MM-DD>`.

Investigation:

```markdown
# <symptom or question>

## Context
<where it showed up, environment, links to issue / PR / logs>
## Evidence
<what was actually observed: logs, queries, repros; quote, don't paraphrase>
## Analysis
<hypotheses in the order tested, and what ruled each in or out>
## Conclusion
<root cause, or the best-supported explanation and what is still open>
## Follow-ups
- [ ] <action>
```

Session note:

```markdown
# <repo> — <YYYY-MM-DD> — <topic>

## Done
## Decisions
## Open threads
## Next
```

## Style

- Wikilinks for vault-internal references (`[[pr-212-review]]`, or
  `[[scheduling-intelligence/pr-212-review]]` if ambiguous); plain URLs elsewhere.
- Code locations as `lib/foo/bar.ex:42` in backticks, never as wikilinks.
- Callouts (`> [!note]`, `> [!warning]`) and Mermaid blocks render natively.
- The H1 is the title; do not duplicate it as a `title:` property.

## Finding and updating existing notes

Before creating a note, check for one on the same PR or topic:

```bash
V=~/Documents/Obsidian/HOPCo/HOPCo
ls "$V/<repo>/"
grep -ril --include='*.md' '<keyword or PR number>' "$V" | grep -v '/.obsidian/'
```

- Same PR reviewed again: update `pr-<N>-review.md` by appending a
  `## Update <YYYY-MM-DD>` section; do not rewrite earlier findings.
- "What did I note about X": search, then answer citing notes by vault-relative
  path. Write nothing.
- Touch only the note you were asked about; never add frontmatter to or rename
  notes that already exist.

## Guardrails

- No PHI or PII, ever: no real patient/member names, MRNs, DOBs, member or insurance
  IDs, or health details tied to a real person, even when quoting logs or test output.
  Use `Patient A`, `MRN: SAMPLE-001`, relative dates. Colleagues' names in a
  code-review context are fine.
- No secrets: tokens, connection strings, key-vault values. Refer to them by name.
- These note types never go into the repo working directory.
- Finish by reporting the vault-relative path written.
