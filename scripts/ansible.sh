#!/usr/bin/env bash
set -euo pipefail

# === Function: Detect Distro ===
detect_distro() {
  if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    echo "$ID"
  else
    echo "❌ Cannot detect distro." >&2
    exit 1
  fi
}

# === Function: Install Ansible ===
install_ansible() {
  echo "📦 Installing ansible directly via package manager..."
  DISTRO=$(detect_distro)

  case "$DISTRO" in
    ubuntu|debian)
      sudo apt-get update -y
      sudo apt-get install -y ansible
      ;;
    fedora)
      sudo dnf install -y ansible
      ;;
    arch)
      sudo pacman -Sy --noconfirm ansible
      ;;
    alpine)
      echo "⚠️ Alpine users must enable the community repository in /etc/apk/repositories"
      sudo apk update
      sudo apk add --no-cache ansible
      ;;
    *)
      echo "❌ Unsupported distro: $DISTRO"
      exit 1
      ;;
  esac

  echo "✅ Ansible installed: $(ansible --version | head -n 1)"
}

# === Function: Require a Command ===
require_command() {
  local cmd="$1"
  if ! command -v "$cmd" &>/dev/null; then
    echo "🔍 Command '$cmd' not found, attempting to install..."
    if [[ "$cmd" == "ansible" ]]; then
      install_ansible
    else
      echo "❌ No installation logic defined for '$cmd'"
      exit 1
    fi
  else
    echo "✅ Command '$cmd' is available"
  fi
}

run_ansible_playbook() {
  local variant="$1"
  local root_dir
  root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

  local ansible_dir="$root_dir/ansible"
  local playbook="$ansible_dir/${variant}.playbook.yml"
  local cfg="$ansible_dir/ansible.cfg"
  local inventory="$ansible_dir/inventory.yml"
  local vars="$ansible_dir/vars.yml"
  local roles_path="$ansible_dir/roles"

  require_command ansible

  if [[ -f "$playbook" ]]; then
    echo "📜 Running Ansible Playbook for variant: $variant"

    export ANSIBLE_CONFIG="$cfg"
    export ANSIBLE_ROLES_PATH="$roles_path"
    export PATH="$HOME/.local/share/mise/shims:$PATH"

    ansible-playbook -i "$inventory" --extra-vars "@$vars" "$playbook" --ask-become-pass
  else
    echo "❌ Ansible playbook not found at $playbook"
    exit 1
  fi
}
