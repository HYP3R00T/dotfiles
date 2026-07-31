# Aliases are enabled only when their corresponding tools are available.

if (( $+commands[python3] )); then
    alias py='python3'
    alias pya='source ./.venv/bin/activate'
fi

if (( $+commands[kubectl] )); then
    alias k='kubectl'
fi

if (( $+commands[terraform] )); then
    alias tf='terraform'
fi

if (( $+commands[lazydocker] )); then
    alias ld='lazydocker'
fi

if (( $+commands[bat] )); then
    alias cat='bat'
fi

if (( $+commands[eza] )); then
    alias ls='eza -al --icons --group-directories-first --git --time-style=relative'
    alias tree='eza --tree --icons --git-ignore -a'
fi
