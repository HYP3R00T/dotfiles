# Smarter directory navigation through the cd command.

(( $+commands[zoxide] )) || return 0
_zsh_source_command_cache zoxide zoxide init zsh --cmd cd
