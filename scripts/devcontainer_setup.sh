#!/usr/bin/env bash
set -euo pipefail

readonly repo_dir="/workspaces/chezmoi"
readonly mise_dir="$repo_dir/mise"

/usr/local/bin/mise trust "$repo_dir/mise.toml"
/usr/local/bin/mise -C "$repo_dir" install
/usr/local/bin/mise trust "$mise_dir/devcontainer.mise.toml" --yes
MISE_OVERRIDE_CONFIG_FILENAMES="devcontainer.mise.toml" /usr/local/bin/mise -C "$mise_dir" bootstrap --yes
