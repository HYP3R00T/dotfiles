#!/usr/bin/env bash
set -euo pipefail

VARIANT="${1:-workstation}"
REPO_URL="https://github.com/HYP3R00T/dotfiles"

# Where this script lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# If we're not in a real clone (no .git, or missing scripts/ or missing the variant script), clone
if [[ ! -d "$SCRIPT_DIR/.git" ]] \
   || [[ ! -d "$SCRIPT_DIR/scripts" ]]; then

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

install_ansible()   { handle_ansible   "$VARIANT"; }
install_mise()      { handle_mise      "$VARIANT"; }
install_chezmoi()   { handle_chezmoi   "$VARIANT"; }

main() {
  case "$VARIANT" in
    workstation)
      install_ansible
      install_mise
      install_chezmoi
      ;;
    wsl)
      install_ansible
      install_mise
      install_chezmoi
      ;;
    devcontainer)
      install_mise
      install_chezmoi
      ;;
    *)
      echo "❌ Unknown variant: $VARIANT"
      exit 1
      ;;
  esac
}

main
