export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

plugins=(
    git
    docker
    zsh-autosuggestions
    zsh-syntax-highlighting
    )

source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"

alias py="python3"
alias pya="source ./.venv/bin/activate"