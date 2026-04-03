#!/usr/bin/env bash
set -euo pipefail

handle_chezmoi() {
  local variant="${1:-devcontainer}"

  # Determine root directory of the repo (one level above the script directory)
  local root_dir
  root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

  # Compose the config file path inside the repo
  local chezmoi_config="${root_dir}/chezmoi/chezmoi.${variant}.yaml"

  if ! command -v chezmoi &>/dev/null; then
    echo "📦 Installing chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    export PATH="$HOME/.local/bin:$PATH"
  fi

  if [[ ! -f "$chezmoi_config" ]]; then
    echo "❌ Config file for variant '$variant' not found at: $chezmoi_config"
    exit 1
  fi

  echo "⚙️ Applying dotfiles with chezmoi for variant: $variant..."

  # Initialize chezmoi repo if not already done
  if [[ ! -d "$HOME/.local/share/chezmoi" ]]; then
    chezmoi init --config="$chezmoi_config" https://github.com/HYP3R00T/dotfiles
  fi

  # Apply dotfiles using the variant-specific config
  chezmoi apply --config="$chezmoi_config"
}
