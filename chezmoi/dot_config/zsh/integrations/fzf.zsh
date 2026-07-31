# FZF completion and ZLE widgets.

(( $+commands[fzf] )) || return 0

# Catppuccin Mocha: https://github.com/catppuccin/fzf
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#313244,label:#CDD6F4 \
--multi"

# Widget bindings require a terminal-backed line editor.
[[ -t 0 ]] && _zsh_source_command_cache fzf fzf --zsh
