export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

plugins=(
    git
    docker
    zsh-autosuggestions
    zsh-syntax-highlighting
    )

# source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH/oh-my-zsh.sh

# Add to path variable
# path+=('$HOME/.local/bin')
# export PATH

# Alt method for the above
export PATH=/home/hyperoot/.local/bin:$PATH

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(pyenv virtualenv-init -)"

alias py="python3"
alias pya="source ./.venv/bin/activate"
alias tcard="python3 -m terminal_card"
alias cd="z"

function tnew() {
    local parent_name="$(basename "$(dirname "$(pwd)")"| tr -d "[:space:]-")"
    local current_name="$(basename "$(pwd)" | tr -d "[:space:]-")"
    local session_name="${parent_name}_${current_name}"
    
    if tmux has-session -t "$session_name" 2>/dev/null; then
        tmux attach-session -t "$session_name"
    else
        tmux new-session -s "$session_name"
    fi
}
alias tm='tnew'
