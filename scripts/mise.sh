#!/usr/bin/env bash
set -euo pipefail

mise_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../mise" && pwd)"

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

  local -a configs=(dotfiles.mise.toml)
  if [[ -n "$profile" ]]; then
    configs+=("$profile.mise.toml")
  fi
  if [[ "$profile" == workstation && -f /usr/share/omarchy/default/hypr/omarchy.lua ]]; then
    configs+=(omarchy.mise.toml)
  fi

  local config
  for config in "${configs[@]}"; do
    "$mise_bin" trust "$mise_dir/$config"
  done
  local filenames
  filenames="$(IFS=:; echo "${configs[*]}")"
  MISE_OVERRIDE_CONFIG_FILENAMES="$filenames" "$mise_bin" -C "$mise_dir" "$@"
}
