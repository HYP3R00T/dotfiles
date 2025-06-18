#!/usr/bin/env bash
set -euo pipefail

handle_chezmoi() {
  local variant="${1:-workstation}"

  if ! command -v chezmoi &>/dev/null; then
    echo "📦 Installing chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    export PATH="$HOME/.local/bin:$PATH"
  fi

  echo "⚙️ Applying dotfiles with chezmoi for variant: $variant..."
  chezmoi init --apply https://github.com/HYP3R00T/dotfiles
}
