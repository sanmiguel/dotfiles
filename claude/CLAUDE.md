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
- Use `with` for chains of operations that can fail, not nested `case`
- Tests go in `test/` mirroring the `lib/` structure; use `describe` blocks and `setup` for shared state
- Tag slow/integration tests with `@moduletag :integration` so they can be excluded with `mix test --exclude integration`

## Testing Workflow

- Run individual tests with `mix test path/to/test.exs:line_number`
- Use `mix test --failed` to re-run only failing tests
- Use `mix test --trace` for verbose output when debugging

## Debugging

- Before proposing a fix, read the actual logs/errors
- State what evidence supports the diagnosis
- Don't theorise past the evidence — if the first explanation is wrong, find more data rather than trying a different theory

## Formatting & Style

- Always run `mix format` before considering code done
- Follow standard Elixir naming: `snake_case` for functions/variables, `PascalCase` for modules
- Prefer explicit over clever — no overly terse one-liners that sacrifice readability

## Prompt Contracts (Planning Workflow)

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

Contracts get shorter over time — the permanent constraints in this file do the
heavy lifting, so each contract only needs the task-specific parts.

If the task is trivial (single-line fix, simple rename, etc.), skip the contract
and just do it.

## Review Reminders

- **2026-03-04**: Review how the Prompt Contract workflow is going. Is it helping?
  Too heavy for some tasks? Need to adjust the threshold for when it kicks in?
  Discuss with the user and revise the instructions above based on experience.
