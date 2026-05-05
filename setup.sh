#!/usr/bin/env bash
set -euo pipefail

VARIANT="${1:-devcontainer}"
REPO_URL="https://github.com/HYP3R00T/dotfiles"

# Where this script lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# If we're not in a real clone (no .git, or missing scripts/ or missing the variant script), clone
if [[ ! -d "$SCRIPT_DIR/.git" ]] ||
  [[ ! -d "$SCRIPT_DIR/scripts" ]]; then

  echo "📦 Not a full clone or missing files; cloning dotfiles repo into temp dir..."
  TMP_DIR="$(mktemp -d)"
  git clone --depth 1 "$REPO_URL" "$TMP_DIR"

  echo "🚀 Re-running setup.sh from cloned repo with variant: $VARIANT"
  exec bash "$TMP_DIR/setup.sh" "$VARIANT"
fi

# From here on, we're in a full repo clone that has everything
echo "🏠 Detected local clone at $SCRIPT_DIR — running bootstrap for: $VARIANT"

# Source your three helpers
source "$SCRIPT_DIR/scripts/ansible.sh"
source "$SCRIPT_DIR/scripts/mise.sh"
source "$SCRIPT_DIR/scripts/chezmoi.sh"

main() {
  case "$VARIANT" in
  workstation)
    handle_ansible "$VARIANT"
    handle_mise "$VARIANT"
    handle_chezmoi "$VARIANT"
    ;;
  wsl)
    handle_ansible "$VARIANT"
    handle_mise "$VARIANT"
    handle_chezmoi "$VARIANT"
    ;;
  devcontainer)
    handle_ansible "$VARIANT"
    handle_mise "$VARIANT"
    handle_chezmoi "$VARIANT"
    ;;
  *)
    echo "❌ Unknown variant: $VARIANT"
    exit 1
    ;;
  esac
}

main
