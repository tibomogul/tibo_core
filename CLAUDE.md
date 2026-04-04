# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

TiboCore is a **Rails 8.1 mountable engine template** with namespace isolation (`TiboCore::`) and the Solid trifecta (Solid Queue, Solid Cache, Solid Cable), Tailwind CSS v4, and Importmap Rails. It's designed to be cloned via `bin/clone_engine` to generate new engines with automatic namespace renaming.

## Commands

All commands run inside the Docker container:

```bash
docker compose exec rails bash -lc 'RAILS_ENV=test bundle exec rspec'                            # Run all specs
docker compose exec rails bash -lc 'RAILS_ENV=test bundle exec rspec spec/integration/solid_stack_spec.rb'  # Run single spec file
docker compose exec rails bash -lc 'bundle exec rubocop'                                          # Lint
docker compose exec rails bash -lc 'bundle exec rubocop -a'                                       # Auto-fix lint
docker compose exec rails bash -lc 'bin/setup'                                                    # First-time DB setup + dev server deps
docker compose exec -d rails bash -lc 'bin/dev'                                                   # Start dev server (Foreman: web + css + worker)
bin/clone_engine /path/to/tibo_core NewEngineName                                                 # Generate new engine from template (run on host)
```

> **Note:** Always prefix `bundle exec rspec` with `RAILS_ENV=test`. The container has `RAILS_ENV=development` set in its environment, which overrides the `||=` default in `rails_helper.rb`.

## Architecture

This is a **Rails engine gem** (not a standalone app). All application code lives under the `TiboCore::` namespace via `isolate_namespace TiboCore` in `lib/tibo_core/engine.rb`.

- `lib/tibo_core.rb` — main entry point, requires Solid gems, Tailwind, Importmap
- `lib/tibo_core/engine.rb` — engine configuration with namespace isolation
- `spec/dummy/` — full Rails 8.1 app used for testing the engine (has its own config, routes, db); uses **Tailwind CSS v4** and **DaisyUI** for styling
- Engine is mounted at `/tibo_core` in the dummy app's routes

### Multi-Database (Solid Trifecta)

The dummy app uses four separate SQLite databases: `primary`, `queue`, `cache`, `cable`. Each Solid gem requires `connects_to` configuration in environment files (e.g., `config.solid_queue.connects_to = { database: { writing: :queue } }`).

**Critical:** Do NOT use both `database:` keys in `database.yml` AND `connects_to` in environment config — they conflict.

## Testing Gotchas

- Use `stub_const` for inline job classes in specs (Solid Queue requires named classes)
- SolidCache hashes keys internally — don't query the DB by raw key name
- Use `TiboCore::Engine.routes.url_helpers` for engine route helpers in specs
- Use `main_app.` prefix for host app routes within engine context
- FactoryBot factories go in `spec/factories/`, auto-loaded via engine initializer

## UI Development

### Dummy App
Use **DaisyUI** components for all UI work in the dummy app. Reference docs: https://daisyui.com/llms.txt

### Engine
Use **Tailwind CSS v4 only** — no DaisyUI dependency. Engine styles must be self-contained and must not rely on DaisyUI being present in the host app. However, ensure engine styles are compatible with DaisyUI (i.e. they don't conflict when DaisyUI is also loaded).

## Code Style

RuboCop with `rubocop-rails-omakase` (Rails official style). Ruby 3.3.4.
