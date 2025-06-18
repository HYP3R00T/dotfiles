#!/usr/bin/env bash

set -euo pipefail

VARIANT="${1:-workstation}" # default to 'workstation'
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$ROOT_DIR/scripts"

# Check variant script exists
if [[ ! -f "$SCRIPTS_DIR/$VARIANT.sh" ]]; then
  echo "❌ Unknown variant: $VARIANT"
  echo "Available variants: workstation, wsl, devcontainer"
  exit 1
fi

echo "🛠️ Running bootstrap for: $VARIANT"
bash "$SCRIPTS_DIR/$VARIANT.sh"
