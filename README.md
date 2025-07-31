# 🌾 farmOS Development Environment

A **Docker-based development environment** for [farmOS](https://farmos.org/) — an open-source farm management system.

---

## ✅ Prerequisites

Make sure you have the following installed:

- Docker & Docker Compose  
- Git  
- A code editor (e.g. **PHPStorm** recommended for PHP development)

---

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone <your-repo-url>
cd farm-manager
```

### 2. Run the Setup Script

```bash
./setup.sh
```

This script will:

- Start Docker containers (PostgreSQL + farmOS)
- Install composer dependencies
- Install farmOS with development settings
- Create an admin account (`admin` / `admin`)
- Generate a one-time login link

### 3. Access farmOS

- Web interface: [http://localhost:8080](http://localhost:8080)
- Login using:
  - Username: `admin`
  - Password: `admin`
  - Or use the generated one-time login link

⚠️ **Important**: Change the admin password after first login!

---

## 🛠️ Manual Installation (Alternative)

If you prefer a manual setup:

```bash
# Start containers
docker-compose up -d

# Install dependencies
docker-compose exec www composer install

# Install farmOS via Drush
docker-compose exec www drush site:install farm \
  --db-url=pgsql://farm:farm@db/farm \
  --site-name="My Farm" \
  --account-name=admin \
  --account-pass=your-secure-password \
  --yes
```

---

## 📁 Project Structure

```plaintext
farm-manager/
├── db/                  # PostgreSQL data (git-ignored)
├── www/                 # farmOS application root
│   └── web/
│       └── sites/
│           └── all/
│               └── modules/   # Custom modules go here
├── docker-compose.yml         # Docker services config
├── .gitignore                 # Tracks only sites/ content
└── CLAUDE.md                  # AI assistant notes
```

---

## ⚙️ Common Development Tasks

### Drush Commands

```bash
# Clear caches
docker-compose exec www drush cr

# One-time login link
docker-compose exec www drush uli

# Drupal status
docker-compose exec www drush status

# Update DB
docker-compose exec www drush updatedb

# Export / Import config
docker-compose exec www drush config:export
docker-compose exec www drush config:import
```

### Code Quality

```bash
# CodeSniffer
docker-compose exec www vendor/bin/phpcs --standard=phpcs.xml web/modules/custom

# PHPStan
docker-compose exec www vendor/bin/phpstan analyse --configuration=phpstan.neon

# PHPUnit
docker-compose exec www vendor/bin/phpunit --configuration=phpunit.xml
```

### Database Management

```bash
# PostgreSQL shell
docker-compose exec db psql -U farm -d farm

# Backup
docker-compose exec db pg_dump -U farm farm > backup.sql

# Restore
docker-compose exec db psql -U farm farm < backup.sql
```

---

## 🔁 Development Workflow

### 1. Custom Module Development

- Create modules in:  
  `www/web/sites/all/modules/custom/`
- Follow [Drupal coding standards](https://www.drupal.org/docs/develop/standards)
- Write automated tests where possible

### 2. Theme Customization

- farmOS uses the **Gin** admin theme
- Add themes in:  
  `www/web/sites/all/themes/custom/`
- Refer to the [Gin Theme Docs](https://www.drupal.org/docs/contributed-themes/gin-admin-theme/custom-theming)

### 3. Configuration Management

- Export config:  
  ```bash
  docker-compose exec www drush config:export
  ```
- Stored in:  
  `www/web/sites/default/files/config_*/`

---

## 🗂 File Storage

farmOS uses two file storage locations:

- **Public files**:  
  `www/web/sites/default/files/` — accessible by anyone

- **Private files**:  
  `www/web/sites/default/private/` — secure storage (e.g. logs, uploads)

To verify private file storage:

```bash
docker-compose exec www drush config:get system.file path.private
```

---

## 🐞 Debugging

### Enable XDebug

- XDebug is pre-configured in `docker-compose.override.yml`
- To use with PHPStorm:
  1. Set up a *PHP Remote Debug* config
  2. Server: `localhost`
  3. Map project path to `/opt/drupal`

### View Logs

```bash
# PHP/Apache logs
docker-compose logs -f www

# PostgreSQL logs
docker-compose logs -f db

# Drupal watchdog logs
docker-compose exec www drush watchdog:show
```

---

## 🧯 Troubleshooting

### Container Won’t Start?

```bash
# Check for port conflicts
lsof -i :8080
lsof -i :5432

# Reset containers (WARNING: data loss)
docker-compose down -v
docker-compose up -d
```

### Permission Issues

```bash
# Reset file permissions
docker-compose exec www chown -R www-data:www-data /opt/drupal/web/sites/default/files
```

### Database Connection Details

- Host: `db` (from inside containers)
- Database: `farm`
- Username: `farm`
- Password: `farm`

---

## 📚 Additional Resources

- 🌱 [farmOS Documentation](https://farmos.org/)  
- 📊 [farmOS Data Model](https://farmos.org/model/)  
- 🛠 [farmOS Development Guide](https://farmos.org/development/)  
- 🐘 [Drupal Documentation](https://www.drupal.org/docs)  
- 🎨 [Gin Theme Docs](https://www.drupal.org/docs/contributed-themes/gin-admin-theme)

---

## 📄 License

This project is licensed under the **GPL-2.0+** license.  
See the official [farmOS repository](https://github.com/farmOS/farmOS) for full license details.
