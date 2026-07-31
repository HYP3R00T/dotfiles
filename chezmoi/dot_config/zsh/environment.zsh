# Environment variables and executable search path.

export COLORTERM=truecolor

typeset -gU path PATH
path=(
    "$HOME/.local/bin"
    $path
)
export PATH

typeset -g ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p -- "$ZSH_CACHE_DIR/completion"
