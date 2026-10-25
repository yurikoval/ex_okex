# AGENTS.md

## Purpose

ExOkex is an Elixir client for the legacy OKEx v3 HTTP and WebSocket APIs. Keep changes small and preserve the published client API unless the task explicitly changes it.

## Repository map

- `lib/ex_okex.ex` — top-level public API.
- `lib/ex_okex/{spot,futures,swap}/` — market-specific facades, endpoint modules, and response structs.
- `lib/ex_okex/api.ex` — shared URL, query-string, and response handling.
- `lib/ex_okex/api/private.ex` and `lib/ex_okex/auth.ex` — authenticated transport and request signing.
- `lib/ex_okex/config.ex` — explicit, application, and environment-based credential resolution.
- `lib/ex_okex/ws.ex` — `use ExOkex.Ws` macro and WebSockex callbacks.
- `test/test_helper.exs` — canonical HTTPoison mock helpers.
- `fixture/vcr_cassettes/` — recorded HTTP fixtures.
- `bin/test` — authoritative full validation pipeline.

## Setup and validation

```bash
asdf install # when using asdf; versions are pinned in .tool-versions
mix deps.get
mix format --check-formatted
mix test path/to/focused_test.exs
bin/test
```

`bin/test` runs Hex retirement and advisory checks, warning-free dev and test compilation, the test suite, Credo, and Dialyzer. Run focused tests while iterating, then the full script before handing off.

The package supports only Elixir 1.20 on Erlang/OTP 29. `.tool-versions` and CI pin the exact supported versions.

## Implementation conventions

- Keep market facade modules as the documented public surface and delegate operations to small endpoint-specific modules.
- API functions accept an optional final `config \\ nil` argument.
- Preserve the response contract from `ExOkex.Api`: `{:ok, value}`, `{:error, reason}`, or `{:error, body, status_code}`.
- Keep API-provided numeric values as strings unless the endpoint already converts them.
- Use existing market structs and `Mapail.map_to_struct/2` for structured responses.
- Follow `.formatter.exs` and `config/.credo.exs`; avoid unrelated refactors or dependency upgrades.
- Update public typespecs, delegates, and README examples when changing public behavior.
- Modify `mix.lock` through Mix commands, not by hand.

## Testing conventions

- Add or update the matching test under `test/ex_okex/` for behavior changes.
- Reuse `TestHelper.with_mock_request/3` and `http_response/2` for HTTP tests.
- HTTPoison mocks are global; keep affected tests `async: false`.
- Prefer mocks and existing recorded-response fixtures over live API requests.
- Do not regenerate fixtures casually. If regeneration is required, inspect the diff for credentials before committing it.
- WebSocket changes need focused coverage for callback return values, state, heartbeat behavior, and overridable callbacks.

## Sensitive boundaries

- Never commit or log API keys, secrets, passphrases, signatures, or real account responses.
- Signing depends on the exact timestamp, uppercase method, path/query, and encoded body. Treat changes in `auth.ex` and `api/private.ex` as security-sensitive.
- Preserve all three configuration modes in `ExOkex.Config`: default application config, dynamic environment-variable names via `access_keys`, and explicit config structs.
- `ExOkex.Ws` is a macro used by every consumer module; changes there have library-wide impact. Preserve its `defoverridable` callbacks.
- The current WebSocket startup test may connect to the configured endpoint. Do not add further external-network dependencies to tests or use real credentials.

## Completion checklist

1. Inspect `git diff` and keep the change task-scoped.
2. Run `mix format --check-formatted`.
3. Run the smallest relevant tests.
4. Run `bin/test` when feasible; report any skipped or environment-blocked checks explicitly.
5. Confirm fixtures, logs, and diffs contain no credentials.
