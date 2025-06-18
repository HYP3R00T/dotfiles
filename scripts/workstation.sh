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
ANSIBLE_PLAYBOOK="$ANSIBLE_DIR/playbook.yml"
ANSIBLE_ROLES_PATH="$ANSIBLE_DIR/roles"

# === 1. Distro Info ===
if [[ -f /etc/os-release ]]; then
  . /etc/os-release
  DISTRO="$ID"
else
  echo "❌ Cannot detect distro."
  exit 1
fi
echo "🧭 Distro detected: $DISTRO"

# === 2. Install Mise ===
if ! command -v mise &>/dev/null; then
  echo "⬇️ Installing mise..."
  curl https://mise.run | sh
  export PATH="$HOME/.local/share/mise/bin:$HOME/.local/share/mise/shims:$PATH"
fi

# === 3. Install tools via variant-specific .mise.toml ===
if [[ -f "$MISE_FILE" ]]; then
  echo "📦 Installing tools from $MISE_FILE..."
  MISE_CONFIG_FILE="$MISE_FILE" "$HOME/.local/bin/mise" install
else
  echo "⚠️ No mise file found for variant: $VARIANT"
fi

# === 4. Ensure Ansible is installed ===
if ! command -v ansible &>/dev/null; then
  echo "📦 Installing ansible with mise..."
  "$HOME/.local/bin/mise" install pipx
  "$HOME/.local/bin/mise" use -g pipx
  "$HOME/.local/bin/mise" install ansible
fi

# === 5. Run Ansible Playbook ===
if [[ -f "$ANSIBLE_PLAYBOOK" ]]; then
  echo "📜 Running Ansible Playbook for $VARIANT..."

  # Export environment variables needed by Ansible
  export ANSIBLE_CONFIG="$ANSIBLE_CFG"
  export ANSIBLE_ROLES_PATH="$ANSIBLE_ROLES_PATH"

  # Build ansible-playbook command as an array to preserve quoting
  ANSIBLE_CMD=(
    ansible-playbook
    -i "$ANSIBLE_INVENTORY"
    --extra-vars "@$ANSIBLE_VARS"
    "$ANSIBLE_PLAYBOOK"
    --ask-become-pass
  )

  # Run the command with proper env vars
  "${ANSIBLE_CMD[@]}"
else
  echo "❌ Ansible playbook not found at $ANSIBLE_PLAYBOOK"
  exit 1
fi

# === 5. Install chezmoi ===
if ! command -v chezmoi &>/dev/null; then
  echo "📦 Installing chezmoi..."
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
  export PATH="$HOME/.local/bin:$PATH"
fi

echo "⚙️ Applying dotfiles with chezmoi..."
chezmoi init --apply https://github.com/HYP3R00T/dotfiles
