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

# Preview the highlighted path in Ctrl-T; keep other fzf pickers unchanged.
export FZF_CTRL_T_OPTS="
--preview 'if [ -d {} ]; then command eza --oneline --all --color=always --icons=always --group-directories-first -- {} | head -80; elif [ -f {} ]; then command bat --color=always --style=plain --paging=never --wrap=never --line-range=:300 -- {}; else printf \"No regular file or directory to preview\\n\"; fi'
--preview-window 'right,55%,border-left,<100(down,50%,border-top)'
"

# Widget bindings require a terminal-backed line editor.
[[ -t 0 ]] && _zsh_source_command_cache fzf fzf --zsh
