# Zsh completion system and styling.

autoload -Uz compinit
compinit -d "$ZSH_CACHE_DIR/zcompdump"

zstyle ':completion:*' menu no
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR/completion"
