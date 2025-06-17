#!/bin/bash

set -euo pipefail

# Helper Function: Print Messages
log() {
  echo -e "\033[1;32m[INFO]\033[0m $1"
}

error() {
  echo -e "\033[1;31m[ERROR]\033[0m $1"
  exit 1
}

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Point to the scripts directory
SCRIPTS_DIR="$ROOT_DIR/scripts"
source "$SCRIPTS_DIR/wsl.sh"
source "$SCRIPTS_DIR/devcontainer.sh"
source "$SCRIPTS_DIR/workstation.sh"

# Parse CLI flags
is_wsl=0
is_devcontainer=0
is_workstation=0

for arg in "$@"; do
  case "$arg" in
  --wsl) is_wsl=1 ;;
  --devcontainer) is_devcontainer=1 ;;
  --workstation) is_workstation=1 ;;
  *)
    echo "Unknown option: $arg"
    echo "Usage: $0 [--wsl | --devcontainer | --workstation]"
    exit 1
    ;;
  esac
done

# Ensure exactly one mode
total=$((is_wsl + is_devcontainer + is_workstation))
if [ "$total" -ne 1 ]; then
  echo "Error: Please pass exactly one of --wsl, --devcontainer, or --workstation"
  exit 1
fi

# Dispatch
if [ "$is_wsl" -eq 1 ]; then
  wsl_setup
elif [ "$is_devcontainer" -eq 1 ]; then
  devcontainer_setup
elif [ "$is_workstation" -eq 1 ]; then
  workstation_setup
fi

exit 0
