# FZF completion and ZLE widgets.

(( $+commands[fzf] )) || return 0

export FZF_DEFAULT_OPTS=" \
--color=fg:15,bg:0,hl:14 \
--color=fg+:15,bg+:0,hl+:12 \
--color=info:10,prompt:9,pointer:13 \
--color=marker:10,spinner:13,header:6 \
--multi"

# Widget bindings require a terminal-backed line editor.
[[ -t 0 ]] && source <(fzf --zsh)
