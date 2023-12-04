# Docker and System Update Script

This document provides a single-command solution to update system packages and manage Docker containers and images.

## Command

Run the following command in your terminal to:

- Update system packages.
- Upgrade installed packages.
- Remove unnecessary packages.
- Perform Docker operations in the current directory.

```bash
curl -sL https://raw.githubusercontent.com/gs4162/ansible/753986bd6046f35d8a411ace4348f4826af6e9bf/scripts/update-os-docker.sh -o update-os-docker.sh && chmod +x update-os-docker.sh && ./update-os-docker.sh
