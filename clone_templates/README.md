# TiboCore

A **Rails 8.1 mountable engine** pre-configured with RSpec, SimpleCov, and the Solid trifecta (Solid Queue, Solid Cache, Solid Cable).

## Features

### Core Stack
- **Rails 8.1+** - Mountable engine architecture with `isolate_namespace`
- **Solid Queue** - SQL-backed background job processing
- **Solid Cache** - Database-backed caching layer
- **Solid Cable** - Database-backed Action Cable adapter
- **Tailwind CSS** - Utility-first styling via `tailwindcss-rails`
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

## Getting Started

```bash
docker compose up -d
docker compose exec rails bash -lc 'bin/setup'
docker compose exec rails bash -lc 'RAILS_ENV=test bundle exec rspec'
```

## Development Workflow

### Running Tests
```bash
docker compose exec rails bash -lc 'RAILS_ENV=test bundle exec rspec'                  # Run all specs
docker compose exec rails bash -lc 'RAILS_ENV=test bundle exec rspec spec/models/'     # Run specific directory
docker compose exec rails bash -lc 'RAILS_ENV=test bundle exec rspec --format doc'     # Verbose output
```

> **Note:** Always prefix `bundle exec rspec` with `RAILS_ENV=test`. The container has `RAILS_ENV=development` in its environment, which overrides the `||=` default in `rails_helper.rb`.

### Code Coverage
SimpleCov generates an HTML report in `coverage/` after each test run. Open `coverage/index.html` to view detailed metrics.

### Linting
```bash
docker compose exec rails bash -lc 'bundle exec rubocop'     # Check code style
docker compose exec rails bash -lc 'bundle exec rubocop -a'  # Auto-fix offenses
```

### Dummy App (Development Server)
```bash
docker compose exec rails bash -lc 'bin/setup'                                                    # First-time DB setup
docker compose exec -d rails bash -lc 'bin/dev'                                                   # Start dev server (background)
docker compose exec rails bash -lc "ps aux | grep -E 'foreman' | grep -v grep"                   # Check if running
docker compose exec rails bash -lc 'pkill -f foreman || true'                                     # Stop dev server
```

## Integration into a Host Application

```ruby
# Gemfile
gem "tibo_core", path: "../path/to/tibo_core"
```

Then:
```bash
bundle install
bin/rails tibo_core:install:migrations
bin/rails db:migrate
```

Mount the engine in `config/routes.rb`:
```ruby
Rails.application.routes.draw do
  mount TiboCore::Engine => "/tibo_core"
end
```

## Database Configuration Notes

The Solid gems require **multi-database configuration**. The dummy app uses separate databases for:
- `primary` - Main application data
- `queue` - Solid Queue tables
- `cache` - Solid Cache tables
- `cable` - Solid Cable tables

**Important:** Configure `connects_to` in environment files, not `database:` keys in `database.yml`, to avoid conflicts.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
