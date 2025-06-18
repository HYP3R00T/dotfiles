#!/usr/bin/env bash
set -euo pipefail

# === Constants ===
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VARIANT="workstation"
MISE_FILE="$ROOT_DIR/mise/${VARIANT}.mise.toml"
ANSIBLE_DIR="$ROOT_DIR/ansible"
ANSIBLE_CFG="$ANSIBLE_DIR/ansible.cfg"
ANSIBLE_INVENTORY="$ANSIBLE_DIR/inventory.yml"
ANSIBLE_VARS="$ANSIBLE_DIR/vars.yml"
ANSIBLE_PLAYBOOK="$ANSIBLE_DIR/${VARIANT}.playbook.yml"
ANSIBLE_ROLES_PATH="$ANSIBLE_DIR/roles"

# === Import Shared Logic ===
source "$ROOT_DIR/scripts/common.sh"

install_and_run_ansible() {
  require_command ansible

  if [[ -f "$ANSIBLE_PLAYBOOK" ]]; then
    echo "📜 Running Ansible Playbook for $VARIANT..."

    export ANSIBLE_CONFIG="$ANSIBLE_CFG"
    export ANSIBLE_ROLES_PATH="$ANSIBLE_ROLES_PATH"
    export PATH="$HOME/.local/share/mise/shims:$PATH"

    ansible-playbook -i "$ANSIBLE_INVENTORY" --extra-vars "@$ANSIBLE_VARS" "$ANSIBLE_PLAYBOOK" --ask-become-pass
  else
    echo "❌ Ansible playbook not found at $ANSIBLE_PLAYBOOK"
    exit 1
  fi
}

install_and_run_mise() {
  if ! command -v mise &>/dev/null; then
    echo "⬇️ Installing mise..."
    curl https://mise.run | sh
    export PATH="$HOME/.local/share/mise/bin:$HOME/.local/share/mise/shims:$PATH"
  fi

  if [[ -f "$MISE_FILE" ]]; then
    echo "📦 Installing tools from $MISE_FILE..."
    MISE_CONFIG_FILE="$MISE_FILE" "$HOME/.local/bin/mise" install
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
  install_and_run_ansible
  install_and_run_mise
  install_and_configure_dotfiles
}

main "$@"
