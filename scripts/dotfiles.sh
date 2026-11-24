#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=scripts/mise.sh
source "$(dirname "${BASH_SOURCE[0]}")/mise.sh"

ensure_mise
run_mise_profile workstation dot "$@"
