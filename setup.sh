#!/usr/bin/env bash
set -euo pipefail

# increase the counter
# curl -fsS -X POST https://counterhub.fastapicloud.dev/count/dotfiles > /dev/null

VARIANT="${1:-devcontainer}"
REPO_URL="https://github.com/HYP3R00T/dotfiles"

# Determine script dir (uses /nonexistent when piped)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-/nonexistent}")" >/dev/null 2>&1 && pwd || echo /nonexistent)"

# If this isn't a dotfiles clone, clone and re-run
remote_url="$(git -C "$SCRIPT_DIR" remote get-url origin 2>/dev/null || true)"
if [ ! -d "$SCRIPT_DIR/.git" ] || [ ! -d "$SCRIPT_DIR/scripts" ] || [ -z "$remote_url" ] || ! echo "$remote_url" | grep -q 'HYP3R00T/dotfiles'; then
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
    handle_chezmoi
    ;;
  wsl)
    handle_ansible "$VARIANT"
    handle_mise "$VARIANT"
    handle_chezmoi
    ;;
  devcontainer)
    handle_ansible "$VARIANT"
    handle_mise "$VARIANT"
    handle_chezmoi
    ;;
  *)
    echo "❌ Unknown variant: $VARIANT"
    exit 1
    ;;
  esac
}

main
