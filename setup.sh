#!/bin/bash

# farmOS Development Setup Script
# This script automates the initial setup of farmOS

set -e

echo "🚀 Starting farmOS development setup..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Start containers
echo "📦 Starting Docker containers..."
docker-compose up -d

# Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
sleep 10

# Install Drupal dependencies if needed
echo "📚 Installing dependencies..."
docker-compose exec www composer install

# Check if farmOS is already installed
if docker-compose exec www drush status --field=bootstrap | grep -q "Successful"; then
    echo "✅ farmOS is already installed!"
else
    echo "🌱 Installing farmOS..."
    
    # Create required directories
    echo "📁 Creating required directories..."
    docker-compose exec www mkdir -p /opt/drupal/web/sites/default
    docker-compose exec www mkdir -p /opt/drupal/web/sites/default/private
    docker-compose exec www mkdir -p /opt/drupal/web/sites/default/files
    
    # Set proper permissions
    docker-compose exec www chown -R www-data:www-data /opt/drupal/web/sites/default
    
    # Install farmOS with default configuration
    docker-compose exec www drush site:install farm \
        --db-url=pgsql://farm:farm@db/farm \
        --site-name="farmOS Development" \
        --account-name=admin \
        --account-pass=admin \
        --account-mail=admin@example.com \
        --yes
    
    # Configure private file system path
    echo "🔒 Configuring private file system..."
    docker-compose exec www drush config:set system.file path.private 'sites/default/private' -y
    
    # Set file permissions again after installation
    docker-compose exec www chown -R www-data:www-data /opt/drupal/web/sites/default/files
    docker-compose exec www chown -R www-data:www-data /opt/drupal/web/sites/default/private
    docker-compose exec www chmod -R 755 /opt/drupal/web/sites/default/files
    docker-compose exec www chmod -R 755 /opt/drupal/web/sites/default/private
    
    echo "✅ farmOS installation complete!"
    echo ""
    echo "📝 Admin credentials:"
    echo "   Username: admin"
    echo "   Password: admin"
fi

# Clear caches
echo "🧹 Clearing caches..."
docker-compose exec www drush cr

# Generate login link
echo ""
echo "🔗 Generating one-time login link..."
docker-compose exec www drush uli --uri=http://localhost:8080

echo ""
echo "✨ Setup complete! farmOS is ready at http://localhost:8080"
echo ""
echo "📚 Next steps:"
echo "   - Use the login link above to access the admin account"
echo "   - Change the admin password after first login"
echo "   - Start developing in www/web/sites/all/modules/"