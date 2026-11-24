#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mise trust "$repo_dir/mise.toml"
mise -C "$repo_dir" install
exec bash "$repo_dir/setup.sh" devcontainer
