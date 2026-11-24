#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=scripts/mise.sh
source "$(dirname "${BASH_SOURCE[0]}")/mise.sh"

profile=workstation
case "${1:-}" in
  workstation|wsl|devcontainer) profile="$1"; shift ;;
esac

ensure_mise
run_mise_profile "$profile" dot "$@"
