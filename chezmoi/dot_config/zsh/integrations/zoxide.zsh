# Smarter directory navigation through the cd command.

(( $+commands[zoxide] )) || return 0
eval "$(zoxide init zsh --cmd cd)"
