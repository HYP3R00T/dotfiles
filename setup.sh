#!/usr/bin/env bash

set -euo pipefail

# === VARIANT Selection ===
VARIANT="${1:-workstation}"
REPO_URL="https://github.com/HYP3R00T/dotfiles"

# === Detect if being run via curl | bash ===
if [[ ! -d "scripts" || ! -f "scripts/${VARIANT}.sh" ]]; then
  echo "📦 Cloning dotfiles repo to temp dir..."

  TMP_DIR="$(mktemp -d)"
  git clone --depth 1 "$REPO_URL" "$TMP_DIR"

  echo "🚀 Running setup.sh from cloned repo with variant: $VARIANT"
  exec bash "$TMP_DIR/setup.sh" "$VARIANT"
fi

# === Local Execution ===
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$ROOT_DIR/scripts"

if [[ ! -f "$SCRIPTS_DIR/$VARIANT.sh" ]]; then
  echo "❌ Unknown variant: $VARIANT"
  echo "Available variants: workstation, wsl, devcontainer"
  exit 1
fi

echo "🛠️ Running bootstrap for: $VARIANT"
bash "$SCRIPTS_DIR/$VARIANT.sh"
