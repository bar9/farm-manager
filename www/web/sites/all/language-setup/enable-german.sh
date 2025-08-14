#!/bin/bash
# Enable German language in farmOS/Drupal
# This script sets up German as the default language for a farmOS instance

echo "🇩🇪 Setting up German language for farmOS..."

# Enable necessary modules
echo "Enabling language modules..."
drush pm:enable locale content_translation -y

# Add German language if not exists
echo "Adding German language..."
drush eval "
  \$languages = \Drupal::languageManager()->getLanguages();
  if (!isset(\$languages['de'])) {
    \$language = \Drupal\language\Entity\ConfigurableLanguage::createFromLangcode('de');
    \$language->save();
    print 'German language added.';
  } else {
    print 'German language already exists.';
  }
"

# Set German as default language
echo "Setting German as default language..."
drush config:set system.site default_langcode de -y

# Configure language negotiation to use site default
echo "Configuring language negotiation..."
drush eval "
  \$config = \Drupal::configFactory()->getEditable('language.types');
  \$negotiation = \$config->get('negotiation');
  \$negotiation['language_interface']['enabled'] = ['language-selected' => 11];
  \$negotiation['language_interface']['method_weights'] = ['language-selected' => -10];
  \$config->set('negotiation', \$negotiation)->save();
  print 'Language negotiation updated.';
"

# Set German as preferred language for all existing users
echo "Setting German for all users..."
drush sql:query "UPDATE users_field_data SET langcode = 'de', preferred_langcode = 'de', preferred_admin_langcode = 'de' WHERE uid > 0"
drush sql:query "UPDATE users SET langcode = 'de' WHERE uid > 0"

# Download and import German translations
echo "Downloading German translations..."
drush locale:check
drush locale:update

# Import custom farmOS translations if available
if [ -f "/opt/drupal/web/sites/all/translations/farmos-custom-de.po" ]; then
  echo "Importing custom farmOS German translations..."
  drush locale:import de /opt/drupal/web/sites/all/translations/farmos-custom-de.po --type=customized --override=all
fi

# Clear caches
echo "Clearing caches..."
drush cr

echo "✅ German language setup complete!"
echo "The interface should now be in German."