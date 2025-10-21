#!/bin/bash

# Restore script for Jellyfin configuration and cache
# Usage: ./restore.sh <backup_file>

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Jellyfin data locations (from compose.yml)
CONFIG_DIR="/home/jack/Documents/software/jellyfin/config"
CACHE_DIR="/home/jack/Documents/software/jellyfin/cache"
JELLYFIN_BASE="/home/jack/Documents/software/jellyfin"

if [ $# -eq 0 ]; then
    echo "Usage: $0 <backup_file>"
    echo ""
    echo "Available backups:"
    if [ -d "${SCRIPT_DIR}/backups" ]; then
        ls -lh "${SCRIPT_DIR}/backups"/*.tar.gz 2>/dev/null || echo "No backups found"
    else
        echo "No backups directory found"
    fi
    exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "${BACKUP_FILE}" ]; then
    echo "Error: Backup file not found: ${BACKUP_FILE}"
    exit 1
fi

echo "WARNING: This will replace the current Jellyfin config and cache!"
echo "Config location: ${CONFIG_DIR}"
echo "Cache location: ${CACHE_DIR}"
echo "Backup file: ${BACKUP_FILE}"
read -p "Are you sure you want to continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Restore cancelled."
    exit 0
fi

# Backup current config before restoring
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
if [ -d "${CONFIG_DIR}" ]; then
    CURRENT_CONFIG_BACKUP="${CONFIG_DIR}.backup.${TIMESTAMP}"
    echo "Backing up current config to: ${CURRENT_CONFIG_BACKUP}"
    mv "${CONFIG_DIR}" "${CURRENT_CONFIG_BACKUP}"
fi

if [ -d "${CACHE_DIR}" ]; then
    CURRENT_CACHE_BACKUP="${CACHE_DIR}.backup.${TIMESTAMP}"
    echo "Backing up current cache to: ${CURRENT_CACHE_BACKUP}"
    mv "${CACHE_DIR}" "${CURRENT_CACHE_BACKUP}"
fi

echo "Restoring from backup..."
mkdir -p "${JELLYFIN_BASE}"
cd "${JELLYFIN_BASE}"
tar -xzf "${BACKUP_FILE}"

if [ $? -eq 0 ]; then
    echo "Restore completed successfully!"
    echo "Please restart your container with: docker compose restart"
else
    echo "Error: Restore failed!"
    if [ -d "${CURRENT_CONFIG_BACKUP}" ]; then
        echo "Restoring previous config..."
        mv "${CURRENT_CONFIG_BACKUP}" "${CONFIG_DIR}"
    fi
    if [ -d "${CURRENT_CACHE_BACKUP}" ]; then
        echo "Restoring previous cache..."
        mv "${CURRENT_CACHE_BACKUP}" "${CACHE_DIR}"
    fi
    exit 1
fi
