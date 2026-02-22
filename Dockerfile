# Use the official, stable Mautic 7 image as the foundation
FROM mautic/mautic:7-apache

# STEP 1: Install the native PHP Redis C-extension
# The base image runs as root here, allowing us to safely compile and enable the extension
RUN pecl install redis \
    && docker-php-ext-enable redis

# STEP 2: Shift Working Directory to the Project Root
# The base image defaults to /var/www/html/docroot.
WORKDIR /var/www/html

# STEP 3: Securely install the Symfony Messenger Redis package
# We switch to www-data to ensure Composer doesn't create root-owned files in /var/www/html
USER www-data

# Safely require the package without triggering missing NPM scripts
RUN COMPOSER_HOME=/tmp/composer composer require symfony/redis-messenger --no-interaction --no-scripts

# Pre-compile the Symfony cache so the Redis transport is instantly registered on boot
RUN php bin/console cache:clear

# STEP 4: Restore Entrypoint Permissions
# We MUST drop back to root user and docroot directory at the end. The official Mautic entrypoint script 
# requires root privileges on boot to dynamically fix volume permissions before starting Apache.
USER root
WORKDIR /var/www/html/docroot