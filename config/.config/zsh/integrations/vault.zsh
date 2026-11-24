# Vault's Bash-compatible completion.

(( $+commands[vault] )) || return 0
autoload -Uz +X bashcompinit
bashcompinit
complete -o nospace -C vault vault
