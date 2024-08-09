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

# A better way to handle tmux sessions
function tnew() {
    local parent_name="$(basename "$(dirname "$(pwd)")" | tr -d "[:space:]-")"
    local current_name="$(basename "$(pwd)" | tr -d "[:space:]-")"
    local session_name="Hyperspace"
    local window_name="${current_name}"

    # Check if any tmux session exists
    if tmux list-sessions 2>/dev/null | grep -q "^"; then
        # Check if a window for the current directory already exists
        if tmux list-windows -t "$(tmux display-message -p '#S')" | grep -q "${window_name}"; then
            # If the window exists, switch to it
            tmux select-window -t "$window_name"
        else
            # If the window doesn't exist, create a new one
            tmux new-window -n "$window_name" -c "$(pwd)"
            tmux select-window -t "$window_name"
        fi
        tmux attach-session -t "$(tmux display-message -p '#S')"
    else
        # No existing session, create a new one and attach to it
        tmux new-session -s "$session_name" -n "$window_name" -c "$(pwd)"
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
export PATH=$HOME/.console-ninja/.bin:$PATH

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

# Completion
autoload -Uz compinit && compinit
