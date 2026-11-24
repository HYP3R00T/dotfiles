# Structured shell history and interactive search.

(($+commands[atuin])) || return 0

# Keep the existing prefix-search Up binding, replace fzf's Ctrl-R history widget with Atuin, and leave the optional AI binding disabled.
_zsh_source_command_cache atuin atuin init zsh --disable-up-arrow --disable-ai
