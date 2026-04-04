# TiboCore

**A production-ready Rails 8.1 engine template** pre-configured with RSpec, SimpleCov, and the Solid trifecta (Solid Queue, Solid Cache, Solid Cable).

This repository serves as a **template** for rapidly generating new Rails engines with a modern, batteries-included stack. Use it to create isolated, mountable engines that can be integrated into any Rails 8.1+ application.

## Features

### Core Stack
- **Rails 8.1+** - Mountable engine architecture with `isolate_namespace`
- **Solid Queue** - SQL-backed background job processing
- **Solid Cache** - Database-backed caching layer
- **Solid Cable** - Database-backed Action Cable adapter
- **Tailwind CSS v4** - Utility-first styling via `tailwindcss-rails`
- **DaisyUI** - Component library for the dummy app (engine styles are DaisyUI-free)
- **Importmap Rails** - JavaScript module management without bundling

### Testing & Quality
- **RSpec** - Comprehensive test framework with Rails integration
- **SimpleCov** - Code coverage reporting with custom groups
- **FactoryBot** - Test fixture replacement for clean test data
- **Capybara** - Integration testing for web interfaces
- **Selenium WebDriver** - Browser automation for feature specs

### Architecture Highlights
- Isolated namespace pattern (`TiboCore::`) for clean integration
- Multi-database configuration for Solid gems (queue, cache, cable)
- Full dummy Rails app in `spec/dummy/` for testing the engine
- RuboCop with `rubocop-rails-omakase` for code style

## Quick Start

### Creating a New Engine from Template

Use the provided cloning script to generate a new engine with automatic namespace renaming:

```bash
bin/clone_engine /path/to/tibo_core YourEngineName
```

The script will:
1. ✅ Duplicate the entire engine directory
2. ✅ Recursively rename all files, directories, and content references
3. ✅ Convert `TiboCore` → `YourEngineName` (PascalCase)
4. ✅ Convert `tibo_core` → `your_engine_name` (snake_case)
5. ✅ Convert `tibo-core` → `your-engine-name` (kebab-case for Stimulus/CSS)
6. ✅ Initialize a fresh git repository
7. ✅ Remove build artifacts and cached files

### Post-Clone Setup

After cloning, set up your new engine:

```bash
cd YourEngineName
docker compose up -d
docker compose exec rails bash -lc 'bin/setup'
docker compose exec rails bash -lc 'bundle exec rspec'
```

## Development Workflow

### Running Tests
```bash
docker compose exec rails bash -lc 'bundle exec rspec'                    # Run all specs
docker compose exec rails bash -lc 'bundle exec rspec spec/models/'       # Run specific directory
docker compose exec rails bash -lc 'bundle exec rspec --format doc'       # Verbose output
```

### Code Coverage
SimpleCov generates an HTML report in `coverage/` after each test run. Open `coverage/index.html` to view detailed metrics.

### Linting
```bash
docker compose exec rails bash -lc 'bundle exec rubocop'                  # Check code style
docker compose exec rails bash -lc 'bundle exec rubocop -a'               # Auto-fix offenses
```

### Dummy App (Development Server)
```bash
docker compose exec rails bash -lc "bin/setup"                           # First-time DB setup
docker compose exec rails bash -lc "ps aux | grep -E 'foreman' | grep -v grep" # Check if web and other processes have been started
docker compose exec -d rails bash -lc "bin/dev"                                # Start (background/detached)
docker compose exec rails bash -lc "pkill -f foreman || true"                  # Stop background dev server
```

## Integration into Host Applications

To use a generated engine in a Rails app:

```ruby
# Gemfile
gem "your_engine_name", path: "../path/to/your_engine_name"
```

Then:
```bash
bundle install
bin/rails your_engine_name:install:migrations
bin/rails db:migrate
```

Mount the engine in `config/routes.rb`:
```ruby
Rails.application.routes.draw do
  mount YourEngineName::Engine => "/your_engine"
end
```

## UI Development

### Dummy App
The dummy app (`spec/dummy/`) uses **Tailwind CSS v4** and **DaisyUI** for all UI work. Reference: https://daisyui.com/llms.txt

### Engine
Engine views use **Tailwind CSS v4 only** — no DaisyUI dependency. Engine styles must work standalone in any host app. They should be compatible with DaisyUI (no conflicts) but must not require it.

## Database Configuration Notes

The Solid gems require **multi-database configuration**. The dummy app uses separate databases for:
- `primary` - Main application data
- `queue` - Solid Queue tables
- `cache` - Solid Cache tables
- `cable` - Solid Cable tables

**Important:** Configure `connects_to` in environment files, not `database:` keys in `database.yml` for dev/test environments to avoid conflicts.

## Contributing

This template is designed to be forked and customized. Suggested improvements:
- Additional Solid gem integrations
- Enhanced generator templates
- CI/CD pipeline configurations

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
