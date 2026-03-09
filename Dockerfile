# Use the official, stable Mautic 7 image as the foundation
FROM mautic/mautic:7-apache

# Metadata for the image
LABEL repository="https://github.com/emmanueljet-limited/mautic-redis"
LABEL maintainer="emmanueljet <dev@emmanueljet.com> (https://emmanueljet.com)"
LABEL description="A Mautic Docker image pre-configured with native Redis queue support via Symfony Messenger, designed for highly scalable marketing automation environments."
LABEL org.opencontainers.image.description="A Mautic Docker image pre-configured with native Redis queue support via Symfony Messenger, designed for highly scalable marketing automation environments."
LABEL org.opencontainers.image.documentation="https://github.com/emmanueljet-limited/mautic-redis?tab=readme-ov-file"
LABEL org.opencontainers.image.source="https://github.com/emmanueljet-limited/mautic-redis"
LABEL org.opencontainers.image.url="https://github.com/emmanueljet-limited/mautic-redis"
LABEL org.opencontainers.image.base.name="mautic/mautic:7-apache"
LABEL org.opencontainers.image.version="1.1-mautic7.0.1-apache"
LABEL org.opencontainers.image.vendor="emmanueljet.com"
LABEL org.opencontainers.image.title="mautic-redis"

# Install the native PHP Redis C-extension
RUN pecl install redis \
    && docker-php-ext-enable redis

# Shift Working Directory to the Project Root
WORKDIR /var/www/html

# Securely install the Symfony Messenger Redis package
USER www-data

# Safely require the package without triggering missing NPM scripts
RUN COMPOSER_HOME=/tmp/composer composer require symfony/redis-messenger --no-interaction --no-scripts

# Pre-compile the Symfony cache so the Redis transport is instantly registered on boot
RUN php bin/console cache:clear

# STEP 4: Restore Entrypoint Permissions
USER root
WORKDIR /var/www/html/docroot