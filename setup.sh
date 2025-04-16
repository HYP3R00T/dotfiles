#!/bin/bash

set -euo pipefail

# Ensure GitHub SSH fingerprint is trusted
mkdir -p ~/.ssh
chmod 700 ~/.ssh
ssh-keyscan -t ed25519 github.com >>~/.ssh/known_hosts
chmod 644 ~/.ssh/known_hosts

# Install chezmoi if not already installed
if ! command -v chezmoi >/dev/null; then
    sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/HYP3R00T/dotfiles.git
fi

# Install mise-en-place if not already installed
if ! command -v mise >/dev/null; then
    curl https://mise.run | sh
    # Ensure mise is immediately available in this session
    export PATH="$HOME/.local/bin:$PATH"
fi

exit 0
