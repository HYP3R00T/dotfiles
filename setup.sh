#!/usr/bin/env bash
set -euo pipefail

VARIANT="${1:-workstation}"
REPO_URL="https://github.com/HYP3R00T/dotfiles"

# Determine the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if the scripts directory exists relative to this script
if [[ ! -d "$SCRIPT_DIR/scripts" || ! -f "$SCRIPT_DIR/scripts/${VARIANT}.sh" ]]; then
  echo "📦 Cloning dotfiles repo to temp dir..."

  TMP_DIR="$(mktemp -d)"
  git clone --depth 1 "$REPO_URL" "$TMP_DIR"

  echo "🚀 Running setup.sh from cloned repo with variant: $VARIANT"
  exec bash "$TMP_DIR/setup.sh" "$VARIANT"
fi

echo "🛠️ Running bootstrap for: $VARIANT"
bash "$SCRIPT_DIR/scripts/$VARIANT.sh"
