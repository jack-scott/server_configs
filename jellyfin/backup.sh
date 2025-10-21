#!/bin/bash

# Backup script for Jellyfin configuration and cache
# This script creates a timestamped backup of config and cache directories

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${SCRIPT_DIR}/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/jellyfin_backup_${TIMESTAMP}.tar.gz"

# Jellyfin data locations (from compose.yml)
CONFIG_DIR="/home/jack/Documents/software/jellyfin/config"
CACHE_DIR="/home/jack/Documents/software/jellyfin/cache"

# Create backup directory if it doesn't exist
mkdir -p "${BACKUP_DIR}"

# Check if config directory exists
if [ ! -d "${CONFIG_DIR}" ]; then
    echo "Error: config directory not found at ${CONFIG_DIR}"
    exit 1
fi

# Check if cache directory exists
if [ ! -d "${CACHE_DIR}" ]; then
    echo "Warning: cache directory not found at ${CACHE_DIR}"
    echo "Continuing with config only..."
fi

echo "Creating backup of Jellyfin configuration and cache..."
echo "Backup file: ${BACKUP_FILE}"

# Create tarball of config and cache directories
cd "$(dirname "${CONFIG_DIR}")"
if [ -d "${CACHE_DIR}" ]; then
    tar -czf "${BACKUP_FILE}" \
        --transform='s|.*/jellyfin/config|config|' \
        --transform='s|.*/jellyfin/cache|cache|' \
        jellyfin/config jellyfin/cache
else
    tar -czf "${BACKUP_FILE}" \
        --transform='s|.*/jellyfin/config|config|' \
        jellyfin/config
fi

if [ $? -eq 0 ]; then
    echo "Backup completed successfully!"
    echo "Backup size: $(du -h "${BACKUP_FILE}" | cut -f1)"
    echo "Location: ${BACKUP_FILE}"
else
    echo "Error: Backup failed!"
    exit 1
fi
