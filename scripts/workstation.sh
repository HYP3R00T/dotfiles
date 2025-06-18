#!/usr/bin/env bash
set -euo pipefail

# === Constants ===
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VARIANT="workstation"
MISE_FILE="$ROOT_DIR/mise/${VARIANT}.mise.toml"

# === Import Shared Logic ===
# source "$ROOT_DIR/scripts/common.sh"
source "$ROOT_DIR/scripts/ansible.sh"

install_and_run_mise() {
  if ! command -v mise &>/dev/null; then
    echo "⬇️ Installing mise..."
    curl https://mise.run | sh
    export PATH="$HOME/.local/share/mise/bin:$HOME/.local/share/mise/shims:$PATH"
  fi

  if [[ -f "$MISE_FILE" ]]; then
    echo "📦 Installing tools from $MISE_FILE..."
    MISE_CONFIG_FILE="$MISE_FILE" mise install
  else
    echo "⚠️ No mise file found for variant: $VARIANT"
  fi
}

install_and_configure_dotfiles() {
  if ! command -v chezmoi &>/dev/null; then
    echo "📦 Installing chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    export PATH="$HOME/.local/bin:$PATH"
  fi

  echo "⚙️ Applying dotfiles with chezmoi..."
  chezmoi init --apply https://github.com/HYP3R00T/dotfiles
}

main() {
  run_ansible_playbook "$VARIANT"
  install_and_run_mise
  install_and_configure_dotfiles
}

main "$@"
