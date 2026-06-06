# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Reference docs

- **`doc/project_analysis.md`** — architecture, route map, data model, conventions, known gaps.
- **`doc/contexts/README.md`** — index of per-feature docs (auth, tokens, channels, HTTP layer, controllers). Read the relevant file before working in that area.

## Commands

```bash
mix deps.get           # install dependencies
mix ecto.setup         # create DB, run migrations, seed
mix phx.server         # dev server on http://localhost:4000
mix test               # run all tests (auto-creates/migrates test DB)
mix test test/kumpel_back_web/controllers/auth/auth_controller_test.exs  # single file
mix test --only focus  # tagged tests
mix format             # format code (.formatter.exs)
mix credo              # lint; fix new issues in touched files
mix ecto.migrate       # run pending migrations
mix ecto.rollback      # roll back last migration
mix ecto.reset         # drop + create + migrate + seed
```

## Architecture

**Layers:**

- **`KumpelBack.*` (domain)** — business logic; Ecto changesets, Repo calls, authorization, subscription flow. Returns `{:ok, _}` / `{:error, _}`. No HTTP concerns here.
- **`KumpelBackWeb.*` (web)** — parse params, call facades, render JSON or channel replies. No heavy business rules or multi-step DB orchestration.
- **Schemas** (`Users.User`, `Rooms.Room`) — data shape, changesets, associations. Cross-entity rules go in domain modules.

**Facades pattern** — top-level modules (`KumpelBack.Users`, `KumpelBack.Rooms`, `KumpelBack.Subscription`) delegate to focused submodules via `defdelegate ... to: ..., as: :call`. New domain operations follow `Domain.Action.call/1` or `call/2`.

**Router** — `KumpelBackWeb.Router` forwards `/api` to `ApiRouter`. `ApiRouter` has two scopes: **public** `[:api]` (health, selected reads, login) and **authenticated** `[:api, :auth]` (mutations, `currentUser`, subscribe). Preserve this split.

**Controllers** — thin; use `action_fallback` to `*FallbackController`. JSON rendering in `*Json` modules. Follow existing HTTP status usage (`:created`, `:ok`, `:not_found`, `:bad_request`, `:unauthorized`, `:too_many_requests`).

**Channels** — `UserSocket` at `/socket`; `chat_room:*` → `ChatRoomChannel`. Join auth via `KumpelBack.Rooms.Authorize` and room codes; connection limits, rate limiting, length limits, and HTML sanitization in `ChatRoomChannel`.

**CORS** — `CORSPlug` on `Endpoint` (before `Router`); configured in `config :cors_plug`. Add new front-end origins in `config/config.exs`.

**Secrets** — production values (`DATABASE_URL`, `SECRET_KEY_BASE`, etc.) in `config/runtime.exs`, not compile-time `config.exs`.

## Key conventions

- **`@spec` on every public function** — including `defdelegate`, plug `init/call`, channel `@impl` callbacks, JSON/render helpers, schema `changeset/1–2`. Use accurate types (`String.t()`, `Ecto.Changeset.t()`, `Plug.Conn.t()`, `Phoenix.Socket.t()`, `{:ok, _}` / `{:error, _}`). Place `@spec` immediately above the function.
- Extend existing facades and `call` modules before adding parallel modules.
- `KumpelBack.Repo` used directly in domain modules — no separate repository layer.
- Input validated via Ecto changesets; no separate payload struct layer.
- Destructive DB changes: prefer multi-step migrations (add → backfill → enforce).
- Commit messages: `type(scope): description` (e.g. `fix(channels): cap lobby connections`).

## Testing

`KumpelBack.DataCase`, `KumpelBackWeb.ConnCase`, `KumpelBackWeb.ChannelCase`. Use Ecto Sandbox; `describe` blocks; tuple assertions matching return conventions. Add or update tests for behavior changes.

## Documentation

Docs belong in the same change as the code.

- Update **`doc/project_analysis.md`** when overall architecture, global conventions, route split, or stack changes.
- Update **`doc/contexts/<topic>.md`** for the touched feature (e.g. `authentication.md`, `channels.md`).
- Add a new `doc/contexts/<name>.md` + row in `doc/contexts/README.md` when introducing a major new feature area.
