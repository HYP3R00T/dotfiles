#!/usr/bin/env bash
set -euo pipefail

handle_chezmoi() {
  if ! command -v chezmoi &>/dev/null; then
    echo "📦 Installing chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    export PATH="$HOME/.local/bin:$PATH"
  fi

  echo "⚙️ Applying dotfiles with chezmoi..."

  # Initialize chezmoi repo if not already done
  if [[ ! -d "$HOME/.local/share/chezmoi" ]]; then
    chezmoi init https://github.com/HYP3R00T/dotfiles
  fi

  chezmoi apply
}
