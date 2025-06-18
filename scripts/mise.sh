#!/usr/bin/env bash
set -euo pipefail

handle_mise() {
  set -euo pipefail
  local variant="${1:-workstation}"

  # Compute ROOT_DIR dynamically inside function
  local root_dir
  root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  local mise_file="$root_dir/mise/${variant}.mise.toml"

  if ! command -v mise &>/dev/null; then
    echo "⬇️ Installing mise..."
    curl https://mise.run | sh
    export PATH="$HOME/.local/share/mise/bin:$HOME/.local/share/mise/shims:$PATH"
  fi

  if [[ -f "$mise_file" ]]; then
    echo "📦 Installing tools from $mise_file..."
    MISE_CONFIG_FILE="$mise_file" mise install
  else
    echo "⚠️ No mise file found for variant: $variant"
  fi
}