#!/bin/bash

# Backup script for Starr Apps configurations
# This script creates a timestamped backup of all config directories

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${SCRIPT_DIR}/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/starr_apps_backup_${TIMESTAMP}.tar.gz"

# Create backup directory if it doesn't exist
mkdir -p "${BACKUP_DIR}"

# Check if config directory exists
if [ ! -d "${SCRIPT_DIR}/config" ]; then
    echo "Error: config directory not found at ${SCRIPT_DIR}/config"
    exit 1
fi

echo "Creating backup of Starr Apps configurations..."
echo "Backup file: ${BACKUP_FILE}"

# Create tarball of config directory
cd "${SCRIPT_DIR}"
tar -czf "${BACKUP_FILE}" config/

if [ $? -eq 0 ]; then
    echo "Backup completed successfully!"
    echo "Backup size: $(du -h "${BACKUP_FILE}" | cut -f1)"
    echo "Location: ${BACKUP_FILE}"
else
    echo "Error: Backup failed!"
    exit 1
fi
