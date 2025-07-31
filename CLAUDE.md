# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a farmOS instance - an open-source farm management system built on Drupal 11. The project uses Docker Compose for containerization with PostgreSQL database and farmOS web services.

## Architecture

### Docker Services
- **db**: PostgreSQL 13 database container
- **www**: farmOS 3.x-dev container (Drupal-based)
- 
### Plug-in Architecture
Most of the structure and Tooling is provided by FarmOS, and we adhere strictly to their excellent documentation under https://farmos.org/. Especially the 'Data Model' and 'Development'
pages are meant to be looked up regularly when you plan your next actions.

#### Key farmOS Documentation Links:
- **Main Documentation**: https://farmos.org/
- **Data Model Overview**: https://farmos.org/model/
  - Assets: https://farmos.org/model/type/asset/
  - Logs: https://farmos.org/model/type/log/
  - Quantities: https://farmos.org/model/type/quantity/
  - Terms: https://farmos.org/model/type/term/
- **Development Guide**: https://farmos.org/development/
  - Module Development: https://farmos.org/development/module/
  - API Documentation: https://farmos.org/development/api/
  - Quick Forms: https://farmos.org/development/module/quick/
  - Data Streams: https://farmos.org/development/module/data-stream/
- **Hosting/Installation**: https://farmos.org/hosting/
- **Community Forum**: https://farmos.discourse.group

### GUI
FarmOS is exclusively living in the admin backend of Drupal and uses the Gin theme.
Modifications and enhancements should be in line with https://www.drupal.org/docs/contributed-themes/gin-admin-theme/custom-theming

#### Key Gin Theme Documentation Links:
- **Main Gin Documentation**: https://www.drupal.org/docs/contributed-themes/gin-admin-theme
- **Custom Theming Guide**: https://www.drupal.org/docs/contributed-themes/gin-admin-theme/custom-theming
  - CSS Custom Properties: https://www.drupal.org/docs/contributed-themes/gin-admin-theme/custom-theming#s-css-custom-properties
  - Creating Sub-themes: https://www.drupal.org/docs/contributed-themes/gin-admin-theme/custom-theming#s-creating-a-sub-theme
  - Custom CSS/JS: https://www.drupal.org/docs/contributed-themes/gin-admin-theme/custom-theming#s-custom-css-and-javascript
- **Configuration Options**: https://www.drupal.org/docs/contributed-themes/gin-admin-theme/configuration
- **Module Integration**: https://www.drupal.org/docs/contributed-themes/gin-admin-theme/module-integration
- **Gin Project Page**: https://www.drupal.org/project/gin

### Directory Structure
This repository only contains `/www/web/sites/` checked into git,
where customizations to FarmOS as well as the Gin admin theme happen in modules located under `/www/web/sites/all/modules`.

The directory structure at runtime is mostly being populated by the containers, only `/www/web/sites/` is for development source code.

- `/db/`: PostgreSQL data directory (mounted volume)
- `/www/`: farmOS application root (mounted volume)
  - `/vendor/`: Composer dependencies
  - `/web/`: Drupal web root
    - `/core/`: Drupal core
    - `/modules/`: Contributed modules
    - `/profiles/farm/`: farmOS installation profile
    - `/themes/`: Themes directory
    - `/sites/default/files/`: Public files directory
    - `/sites/default/private/`: Private files directory (for secure file storage)


## Development Commands

All commands should be run from the project root directory using Docker Compose:

### Composer Commands
```bash
docker-compose exec www composer install       # Install dependencies
docker-compose exec www composer update        # Update dependencies
docker-compose exec www composer require       # Add new packages
```

### Drush Commands
```bash
docker-compose exec www drush cr               # Clear all caches
docker-compose exec www drush status           # Check Drupal status
docker-compose exec www drush uli              # Generate one-time login link
docker-compose exec www drush config:export    # Export configuration
docker-compose exec www drush config:import    # Import configuration
docker-compose exec www drush updatedb         # Run database updates
```

### Code Quality Tools
```bash
# PHP CodeSniffer (coding standards)
docker-compose exec www vendor/bin/phpcs --standard=phpcs.xml web/modules/custom

# PHPStan (static analysis)
docker-compose exec www vendor/bin/phpstan analyse --configuration=phpstan.neon

# Rector (automated refactoring)
docker-compose exec www vendor/bin/rector process --config=rector.php --dry-run
```

### Testing
```bash
# Run all tests
docker-compose exec www vendor/bin/phpunit --configuration=phpunit.xml

# Run specific test suite
docker-compose exec www vendor/bin/phpunit --configuration=phpunit.xml --testsuite=unit
docker-compose exec www vendor/bin/phpunit --configuration=phpunit.xml --testsuite=kernel
docker-compose exec www vendor/bin/phpunit --configuration=phpunit.xml --testsuite=functional
docker-compose exec www vendor/bin/phpunit --configuration=phpunit.xml --testsuite=functional-javascript

# Run a specific test
docker-compose exec www vendor/bin/phpunit --configuration=phpunit.xml path/to/test/file.php
```

## Key Configuration Files

- `docker-compose.yml`: Docker services configuration
- `www/composer.json`: Project dependencies
- `www/phpcs.xml`: PHP CodeSniffer rules (Drupal & DrupalPractice standards)
- `www/phpstan.neon`: PHPStan configuration (level 5)
- `www/phpunit.xml`: PHPUnit configuration for testing
- `www/rector.php`: Rector configuration for code upgrades

## Database Connection

The development database uses these credentials:
- Host: `db` (within Docker network)
- Database: `farm`
- Username: `farm`
- Password: `farm`
- Port: `5432`

## Web Access

- farmOS web interface: http://localhost:8080
- XDebug is configured for PHPStorm debugging (see docker-compose.yml)

## Module Development

When developing custom modules:
1. Place them in `www/web/modules/custom/`
2. Follow Drupal coding standards (enforced by phpcs.xml)
3. Use dependency injection where possible
4. Write tests for new functionality
5. Run code quality checks before committing

## Important Notes

- The project uses farmOS 3.x-dev (development version)
- PHP version requirement: 8.2+
- Always use Docker Compose commands to interact with the application
- Database files are stored in the local `db/` directory
- Application files are mounted from the local `www/` directory