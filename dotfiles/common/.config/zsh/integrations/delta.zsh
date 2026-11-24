# Use Delta as Git's pager when it is available.

# shellcheck disable=SC2154 # Zsh's $commands associative array.
(( $+commands[delta] )) || return 0

export GIT_PAGER=delta
