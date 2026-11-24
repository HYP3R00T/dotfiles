# kubectl completion.

(( $+commands[kubectl] )) || return 0
_zsh_source_command_cache kubectl-completion kubectl completion zsh
