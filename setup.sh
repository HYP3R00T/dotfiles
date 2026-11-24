#!/usr/bin/env bash
set -euo pipefail

variant=devcontainer
case "${1:-}" in
  workstation|wsl|devcontainer) variant="$1"; shift ;;
  --*|"") ;;
  *) echo "Unknown variant: $1" >&2; exit 1 ;;
esac

script_dir=""
if [[ -n "${BASH_SOURCE[0]:-}" ]]; then
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

if [[ -z "$script_dir" || ! -f "$script_dir/scripts/mise.sh" || ! -d "$script_dir/dotfiles" ]]; then
  repo_url="https://github.com/HYP3R00T/dotfiles.git"
  checkout="$HOME/Projects/dotfiles"
  if [[ ! -e "$checkout" ]]; then
    git clone "$repo_url" "$checkout"
  fi
  origin="$(git -C "$checkout" remote get-url origin 2>/dev/null || true)"
  case "$origin" in
    https://github.com/HYP3R00T/dotfiles|https://github.com/HYP3R00T/dotfiles.git|git@github.com:HYP3R00T/dotfiles.git) ;;
    *) echo "$checkout is not a checkout of HYP3R00T/dotfiles." >&2; exit 1 ;;
  esac
  if [[ ! -f "$checkout/scripts/mise.sh" || ! -d "$checkout/dotfiles" ]]; then
    echo "Update the dotfiles checkout at $checkout and retry." >&2
    exit 1
  fi
  exec bash "$checkout/setup.sh" "$variant" "$@"
fi

# shellcheck source=scripts/mise.sh
source "$script_dir/scripts/mise.sh"

ensure_mise
if [[ "${1:-}" == --dotfiles-only ]]; then
  shift
  run_mise_profile "$variant" dot apply "$@"
else
  run_mise_profile "$variant" bootstrap --yes "$@"
fi
