Review the changes on this branch relative to `main`.

Setup:
- Diff against the merge-base, not main's tip: `git diff main...HEAD`.
  List the changed files first so nothing is skipped.
- Read the commit messages (and PR description if available) to establish
  what the change is supposed to do. A mismatch between stated intent and
  implementation is itself a finding.
- Do not review the diff in isolation: for each changed function, read
  enough of its callers, callees, and tests to check the invariants it
  participates in.

Scope:
- Flag only issues a careful maintainer would block on before merge.
- Pre-existing problems in untouched code are out of scope unless this
  change makes them worse or newly depends on them.
- Skip pure style, formatting, naming, and anything a linter or CI
  already enforces.

What to look for, in descending severity:
1. Correctness — logic errors, broken invariants, missed edge cases,
   off-by-one, races, error paths that swallow failures.
2. Security — injection, authn/authz mistakes, secret handling, unsafe
   deserialization, unsafe defaults, TOCTOU.
3. Reliability & performance — blocking the wrong thread, unbounded
   resource use, accidental O(N²), retries without backoff, silent
   failure paths.
4. Contract risk — behavior changes callers rely on, silently changed
   defaults, broken backward compatibility, missing migrations.
5. Tests — new behavior with no coverage; assertions weakened or deleted
   to make the suite pass.

Report each finding as:
- Severity (blocker / major / minor) and category
- `file:line` in the post-change code, with the relevant lines quoted
- Failure scenario: the concrete input or state under which this
  misbehaves, and what goes wrong. If you cannot construct one, drop
  the finding.
- A concrete fix when one is obvious; otherwise, what needs deciding.

Order findings most severe first.

Calibration:
- Verify every claim against the actual code — never infer behavior from
  a name or a partial read of the diff.
- Report only findings you would stake a blocking comment on. If a
  finding is plausible but unverified, verify it or drop it. Exception:
  severe-impact issues (data loss, security) you cannot fully verify may
  be reported, explicitly labeled unverified, with the specific check
  needed to confirm.
- If nothing survives that bar, say so plainly. A short review of real
  issues beats a long review of speculation.
