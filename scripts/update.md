# Docker and System Update Script

This document provides a single-command solution to update system packages and manage Docker containers and images.

## Command

Run the following command in your terminal to:

- Update system packages.
- Upgrade installed packages.
- Remove unnecessary packages.
- Perform Docker operations in the current directory.

```bash
sudo sh -c 'apt update && apt full-upgrade -y && apt autoremove -y && cd "$(pwd)" && docker-compose pull && docker-compose up -d && docker image prune -af && docker volume prune -f'
