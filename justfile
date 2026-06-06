# Kumpel backend — Elixir/Phoenix
# Run `just` to list available recipes.

set dotenv-load := false

# List recipes
default:
    @just --list

# ── Dependencies ─────────────────────────────────────────────────────────────

# Install dependencies
deps:
    mix deps.get

# Update dependencies
deps-update:
    mix deps.update --all

# ── Database ──────────────────────────────────────────────────────────────────

# Create DB, run migrations, seed
db-setup:
    mix ecto.setup

# Run pending migrations
db-migrate:
    mix ecto.migrate

# Roll back last migration
db-rollback:
    mix ecto.rollback

# Drop, recreate, migrate, seed
db-reset:
    mix ecto.reset

# ── Dev server ────────────────────────────────────────────────────────────────

# Start Phoenix dev server (port 4000)
dev:
    mix phx.server

# Start in IEx interactive shell
iex:
    iex -S mix phx.server

# ── Code quality ─────────────────────────────────────────────────────────────

# Format all source files
fmt:
    mix format

# Check formatting without writing (CI-safe)
fmt-check:
    mix format --check-formatted

# Run Credo linter
lint:
    mix credo

# Run Credo in strict mode
lint-strict:
    mix credo --strict

# ── Tests ─────────────────────────────────────────────────────────────────────

# Run all tests
test:
    mix test

# Run tests with coverage
test-cover:
    mix test --cover

# Run a single test file, e.g.: just test-file test/kumpel_back/messages/create_test.exs
test-file file:
    mix test {{ file }}

# Run only tests tagged @tag :focus
test-focus:
    mix test --only focus

# Watch mode (requires mix_test_watch dep)
test-watch:
    mix test.watch

# ── Documentation ────────────────────────────────────────────────────────────

# Generate ExDoc HTML docs
docs:
    mix docs

# ── Deploy (Fly.io) ──────────────────────────────────────────────────────────

# Deploy to Fly.io
deploy:
    fly deploy

# Open the deployed app in the browser
open:
    fly open

# Tail production logs
logs:
    fly logs

# SSH into the running machine
ssh:
    fly ssh console

# Run a one-off release command on Fly (e.g. migrations)
fly-migrate:
    fly ssh console -C "/app/bin/migrate"

# Show Fly app status
status:
    fly status
