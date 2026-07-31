# Environment variables and executable search path.

# Keep newly created files private from group writes by default.
umask 022

export COLORTERM=truecolor
# Keep terminal callers blocked until the edited file is closed in Zed.
export EDITOR="zed --wait"
export VISUAL="$EDITOR"

typeset -gU path PATH
path=(
    "$HOME/.local/bin"
    $path
)
export PATH

typeset -g ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[[ -d "$ZSH_CACHE_DIR/completion" ]] || mkdir -p -- "$ZSH_CACHE_DIR/completion"
[[ -d "$ZSH_CACHE_DIR/init" ]] || mkdir -p -- "$ZSH_CACHE_DIR/init"

# Cache shell code emitted by external tools. Regenerate it when the command,
# command path, or invocation changes (for example, after a Mise upgrade).
function _zsh_source_command_cache() {
    local cache_name="$1"
    shift

    local executable="${commands[$1]}"
    local cache_file="$ZSH_CACHE_DIR/init/$cache_name.zsh"
    local signature_file="$cache_file.signature"
    local signature="$executable ${(q)@}"
    local cached_signature=""

    [[ -r "$signature_file" ]] && cached_signature="$(<"$signature_file")"

    if [[ ! -r "$cache_file" || "$executable" -nt "$cache_file" || "$signature" != "$cached_signature" ]]; then
        local temporary_file="$cache_file.tmp.$$"
        if "$@" >| "$temporary_file"; then
            mv -f -- "$temporary_file" "$cache_file"
            print -r -- "$signature" >| "$signature_file"
        else
            rm -f -- "$temporary_file"
            [[ -r "$cache_file" ]] || return 1
        fi
    fi

    source "$cache_file"
}
