#!/bin/bash

# Restore script for SeaweedFS configuration
# Usage: ./restore.sh <backup_file>

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

echo "WARNING: This will replace the current config directory!"
echo "Backup file: ${BACKUP_FILE}"
read -p "Are you sure you want to continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Restore cancelled."
    exit 0
fi

# Backup current config before restoring
if [ -d "${SCRIPT_DIR}/config" ]; then
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    CURRENT_BACKUP="${SCRIPT_DIR}/config.backup.${TIMESTAMP}"
    echo "Backing up current config to: ${CURRENT_BACKUP}"
    mv "${SCRIPT_DIR}/config" "${CURRENT_BACKUP}"
fi

echo "Restoring from backup..."
cd "${SCRIPT_DIR}"
tar -xzf "${BACKUP_FILE}"

if [ $? -eq 0 ]; then
    echo "Restore completed successfully!"
    echo "Please restart your containers with: docker compose restart"
else
    echo "Error: Restore failed!"
    if [ -d "${CURRENT_BACKUP}" ]; then
        echo "Restoring previous config..."
        mv "${CURRENT_BACKUP}" "${SCRIPT_DIR}/config"
    fi
    exit 1
fi
