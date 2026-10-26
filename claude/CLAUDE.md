# Elixir Development Conventions

## Stack

- **Language**: Elixir / Erlang (BEAM) — pure Elixir by default
- **Web** (when a frontend is needed): Phoenix + LiveView — no React, no JS frameworks
- **Database**: Ecto + PostgreSQL
- **Testing**: ExUnit via `mix test`
- **Version management**: mise

## Hard Rules

- Never install a hex dependency without asking first
- Never modify Ecto migrations after they've been committed — always create a new migration
- Never hardcode secrets or config values — use `config/runtime.exs` and env vars
- Never use `Repo.get!` / `Repo.one!` etc. in contexts where the absence is a valid state — use the non-bang variant and handle it
- Don't reach into another context's schema — use the public context API
- Phoenix projects: Tailwind only for styling — never write custom CSS or CSS modules

## Patterns

- Follow the Phoenix Contexts pattern: business logic lives in context modules, controllers/LiveViews are thin
- Prefer pattern matching and multi-clause functions over conditionals where it reads clearly
- For small fixed business-rule matrices (~10 entries or fewer — promotion ladders, permission tables, state transitions), write explicit multi-clause functions rather than rank arithmetic, lookup maps, or other clever encodings. The function body should read as the business rule itself
- Use `with` for chains of operations that can fail, not nested `case`
- Tests go in `test/` mirroring the `lib/` structure; use `describe` blocks and `setup` for shared state
- Tag slow/integration tests with `@moduletag :integration` so they can be excluded with `mix test --exclude integration`

## Debugging

- Before proposing a fix, read the actual logs/errors
- State what evidence supports the diagnosis
- Don't theorise past the evidence — if the first explanation is wrong, find more data rather than trying a different theory

## Formatting & Style

- Always run `mix format` before considering code done
- Prefer explicit over clever — no overly terse one-liners that sacrifice readability

## Prompt Contracts (Planning Workflow)

For any non-trivial task (multi-file changes, new features, architectural
changes, bug investigations), ALWAYS invoke the `prompt-contract` skill
before writing code and follow it through to its final self-review step.
Do not begin implementation until I have approved the contract it produces.

If the task is trivial (single-line fix, simple rename, etc.), skip it and
just do it.

## Worktrees

When you finish a task in a git worktree and have opened the PR, run the
`worktree-context` skill in **save** mode to record the branch's reasoning —
key decisions, dead-ends, and open threads — as a git note on the branch's
first commit. This lets a later session (e.g. one opened to act on PR feedback
after this session is gone) resume with full context. A SessionStart hook
detects the note when you return to the branch and offers **resume** mode.
