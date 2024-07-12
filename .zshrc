# Initiate starship
eval "$(starship init zsh)"

# Activate plugins
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# History
HISTSIZE=2000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion
autoload -Uz compinit && compinit

# Keybindings
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[C' forward-char
bindkey '^[[D' backward-char

# Keybindings workarounds for Windows Terminal
if [[ -n $WT_SESSION ]]; then
    bindkey '^[OA' history-search-backward
    bindkey '^[OB' history-search-forward
    bindkey '^[OC' forward-char
    bindkey '^[OD' backward-char
    export COLORTERM='truecolor'
fi

function tnew() {
    local parent_name="$(basename "$(dirname "$(pwd)")" | tr -d "[:space:]-")"
    local current_name="$(basename "$(pwd)" | tr -d "[:space:]-")"
    local session_name="${parent_name}_${current_name}"

    if tmux has-session -t "$session_name" 2>/dev/null; then
        tmux attach-session -t "$session_name"
    else
        tmux new-session -s "$session_name"
    fi
}

# Aliases
alias tm='tnew'
alias ls='ls --color'
alias py="python3"
alias pya="source ./.venv/bin/activate"
alias cd="z"

# Add to path variable
export PATH=$HOME/.local/bin:$PATH

# zoxide - https://github.com/ajeetdsouza/zoxide
eval "$(zoxide init zsh)"

# nvm - https://github.com/nvm-sh/nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# pyenv - https://github.com/pyenv/pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# python poetry - https://github.com/python-poetry/poetry
fpath+=~/.zfunc
autoload -Uz compinit && compinit
