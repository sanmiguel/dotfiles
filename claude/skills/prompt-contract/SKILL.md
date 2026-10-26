---
name: prompt-contract
description: >-
  Plan non-trivial work (multi-file changes, new features, architectural
  changes, bug investigations) as a Prompt Contract: clarify, draft Goal /
  Constraints / Output Format / Failure Conditions, get explicit approval
  before coding, execute against the contract, then self-review the diff
  before declaring done. Invoke BEFORE writing code on any non-trivial task;
  skip for trivial one-line fixes and renames.
---

# Prompt Contract workflow

For any non-trivial task (multi-file changes, new features, architectural changes,
bug investigations), ALWAYS build a Prompt Contract before writing code:

1. **Clarify** — Ask questions until you can fill in all four sections below.
   Do not assume — ask.
2. **Draft the contract** — Present it for my approval:
   - **Goal**: What "done" looks like, stated as a testable outcome I can verify
     in under a minute. Not "add subscriptions" but "a free user can upgrade to
     Pro, see the charge in Stripe, and access gated features within 5 seconds."
   - **Constraints**: Hard boundaries that cannot be crossed. Task-specific only —
     permanent constraints already live in the Stack / Hard Rules / Patterns
     sections above and don't need repeating in every contract.
   - **Output Format**: Concrete deliverable structure — specify exact file paths,
     module names, function signatures, and return shapes. Not "an API endpoint"
     but "a mutation in `lib/my_app/billing.ex` returning `{:ok, subscription}`
     or `{:error, changeset}`."
   - **Failure Conditions**: The most important section. Define what "bad" looks
     like — these act as guardrails that prevent wrong-direction work. Be specific:
     "uses polling instead of PubSub", "any module exceeds 150 LOC", "missing
     error/loading states." When in doubt, add more failure conditions rather
     than more goal description.
3. **Get explicit approval** — Do not begin implementation until I confirm the contract.
4. **Execute against the contract** — Use Plan Mode for the implementation plan,
   then implement. Reference the contract when making decisions. After completing,
   verify the Goal is met and no Failure Conditions were triggered.
5. **Self-review before declaring done** — Once verification passes (tests
   green, types/credo/dialyzer clean), do a final pass over your own diff
   *before* reporting completion. Look for and fix:
   - **Defensive code for impossible states** — fallback function clauses,
     nil/empty handling for inputs the schema/types/callers can't produce.
     Per YAGNI: delete.
   - **Unnecessary indirection** — helpers that wrap a single call site, or
     two functions that could be one.
   - **Duplicated condition checks** — the same predicate evaluated in
     multiple places. Compute once, name it.
   - **Repetitive templates / markup** — 3+ near-identical blocks that should
     become a tiny private component.
   - **Inaccurate docstrings** — words like "idempotent" or "safely" that the
     implementation doesn't actually deliver.
   - **WHAT-comments** — comments restating what well-named code already says;
     keep only comments explaining WHY (non-obvious constraint, surprising
     behaviour, workaround).

   Re-run verification after cleanups, then report.

Contracts get shorter over time — the permanent constraints in the global CLAUDE.md do the
heavy lifting, so each contract only needs the task-specific parts.

If the task is trivial (single-line fix, simple rename, etc.), skip the contract
and just do it.
