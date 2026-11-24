#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ensure_mise() {
  if command -v mise >/dev/null; then
    mise_bin="$(command -v mise)"
  else
    echo "Installing mise..."
    curl -fsSL https://mise.run | sh
    mise_bin="$HOME/.local/bin/mise"
  fi

  local version
  version="$("$mise_bin" --version)"
  if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+ ]]; then
    echo "Could not determine the mise version: $version" >&2
    return 1
  fi
  if [[ "$(printf '%s\n' 2026.11.12 "${BASH_REMATCH[0]}" | sort -V | head -n 1)" != 2026.11.12 ]]; then
    echo "mise 2026.11.12 or newer is required. Update mise and try again." >&2
    return 1
  fi
}

run_mise_profile() {
  local profile="$1"
  shift

  local mise_dir="$repo_dir/mise"
  local config="$profile.mise.toml"
  local -a env_args=()
  if [[ "$profile" == workstation && -f /usr/share/omarchy/default/hypr/omarchy.lua ]]; then
    env_args=(-E omarchy)
  fi

  "$mise_bin" trust "$mise_dir/$config"
  env -u MISE_ENV MISE_OVERRIDE_CONFIG_FILENAMES="$config" \
    "$mise_bin" -C "$mise_dir" "${env_args[@]}" "$@"
}
