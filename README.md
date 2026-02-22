# Mautic with Native Redis Support

![License](https://img.shields.io/badge/license-AGPLv3-blue.svg)
![Mautic Version](https://img.shields.io/badge/Mautic-7.x-success.svg)
![PHP Version](https://img.shields.io/badge/PHP-8.3-8892BF.svg)

An optimized Mautic Docker image engineered to support high-throughput message processing using Redis. Maintained by the [emmanueljet](https://emmanueljet.com) ecosystem.

## The Problem This Solves

By default, the official `mautic/mautic` Docker image is kept incredibly lean. It relies on the database (Doctrine) for processing background queues and does not include the necessary C-extensions (`ext-redis`) or the Symfony Messenger Redis transport (`symfony/redis-messenger`) required to run memory-based queues out of the box.

In high-volume enterprise environments, relying on database queues can lead to I/O bottlenecks and database locking issues.

This custom image solves that by:

1. Compiling and enabling the native PHP Redis extension.
2. Securely installing the `symfony/redis-messenger` package.
3. Pre-warming the Symfony cache to ensure instant worker registration on boot.
4. Preserving the exact folder permissions and entrypoints of the official Mautic image.

## Usage (Docker Compose)

You can easily drop this image into your existing Docker Compose. Because the Redis dependencies are baked in, you can directly map your Mautic Messenger streams to dedicated Redis databases using environment variables. See [docker-compose.yml](docker-compose.yml) for more details.
