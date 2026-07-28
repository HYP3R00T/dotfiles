#!/usr/bin/env bash
set -euo pipefail

handle_mise() {
  local variant="${1:-devcontainer}"
  local root_dir
  root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  local mise_dir="$root_dir/mise"
  local variant_config="$mise_dir/${variant}.mise.toml"
  local mise_bin

  if command -v mise &>/dev/null; then
    mise_bin="$(command -v mise)"
  else
    echo "⬇️ Installing mise..."
    curl -fsSL https://mise.run | sh
    mise_bin="$HOME/.local/bin/mise"
  fi

  if ! "$mise_bin" bootstrap --help &>/dev/null; then
    echo "❌ mise 2026.7.4 or newer is required for bootstrap support."
    exit 1
  fi

  if [[ ! -f "$variant_config" ]]; then
    echo "❌ mise configuration not found for variant: $variant"
    exit 1
  fi

  echo "📦 Bootstrapping system packages and tools for variant: $variant..."
  "$mise_bin" trust "$variant_config" --yes
  MISE_OVERRIDE_CONFIG_FILENAMES="${variant}.mise.toml" "$mise_bin" -C "$mise_dir" bootstrap --yes
}
