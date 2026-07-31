# kubectl completion.

(( $+commands[kubectl] )) || return 0
source <(kubectl completion zsh)
