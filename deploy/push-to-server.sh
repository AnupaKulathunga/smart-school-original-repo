#!/bin/bash
set -euo pipefail

###############################################################################
# Push Smart School TVET to production server
# Run this from your LOCAL machine (macOS)
###############################################################################

SERVER="4.221.231.33"
SERVER_USER="boxadmin"
REMOTE_DIR="/var/www/smart-school-tvet"
LOCAL_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "=== Smart School TVET — Push to Server ==="
echo "Local:  ${LOCAL_DIR}"
echo "Remote: ${SERVER_USER}@${SERVER}:${REMOTE_DIR}"
echo ""

# Step 1: Ensure remote directory exists
echo "[1/3] Creating remote directory..."
ssh "${SERVER_USER}@${SERVER}" "sudo mkdir -p ${REMOTE_DIR} && sudo chown ${SERVER_USER}:${SERVER_USER} ${REMOTE_DIR}"

# Step 2: Rsync files to server (excluding git, node_modules, etc.)
echo "[2/3] Syncing files to server..."
rsync -avz --progress \
    --exclude='.git' \
    --exclude='node_modules' \
    --exclude='tests/node_modules' \
    --exclude='.claude' \
    --exclude='*.png' \
    --exclude='playwright.config.ts' \
    --exclude='test-login.js' \
    "${LOCAL_DIR}/" "${SERVER_USER}@${SERVER}:${REMOTE_DIR}/"

# Step 3: Make scripts executable on server
echo "[3/3] Setting permissions..."
ssh "${SERVER_USER}@${SERVER}" "chmod +x ${REMOTE_DIR}/deploy/deploy.sh ${REMOTE_DIR}/deploy/rollback.sh ${REMOTE_DIR}/deploy/docker-entrypoint-production.sh"

echo ""
echo "=== Files pushed successfully ==="
echo ""
echo "Next steps — SSH into the server and run:"
echo "  ssh ${SERVER_USER}@${SERVER}"
echo "  sudo ${REMOTE_DIR}/deploy/deploy.sh"
echo ""
