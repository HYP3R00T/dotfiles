# Elan Lean toolchain manager.

[[ -d "$HOME/.elan/bin" ]] || return 0
path=("$HOME/.elan/bin" $path)
