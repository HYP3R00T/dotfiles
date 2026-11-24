# pnpm global executables.
# shellcheck disable=SC2206 # This file uses Zsh array semantics.

export PNPM_HOME="$HOME/.local/share/pnpm/bin"
path=("$PNPM_HOME" $path)
