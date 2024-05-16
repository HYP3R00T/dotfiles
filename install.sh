#!/bin/bash

# Update and upgrade packages
sudo apt update && sudo apt upgrade -y

# Install prerequisites
sudo apt install nala -y

# Install packages
sudo nala install git stow tmux zsh neofetch fzf build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl git libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y

# Install zoxide
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" <<< $'\n'

# Install Starship prompt
sh -c "$(curl -fsSL https://starship.rs/install.sh)"

# Install pyenv
curl https://pyenv.run | bash

# Install python version 3.10 and 3 (latest)
pyenv install 3.10
pyenv install 3

#Install python-poetry
curl -sSL https://install.python-poetry.org | python3 -

# Change default shell to zsh
chsh -s $(which zsh)

# Clone zsh-autosuggestions plugin
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Clone zsh-syntax-highlighting plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Remove default files and folders that might have been created while installing
paths_to_delete=(
    "$HOME/.config"
    "$HOME/.tmux.conf"
    "$HOME/.zshrc"
)

# Loop through each file/folder
for item in "${paths_to_delete[@]}"; do
    # Check if the file/folder exists
    if [ -e "$item" ]; then
        # If it exists, delete it
        echo "Deleting $item..."
        rm -rf "$item"
    else
        # If it doesn't exist, print a message
        echo "$item does not exist."
    fi
    echo "Items deleted"
done

# Clone dotfiles repository
git clone https://github.com/HYP3R00T/.dotfiles ~/.dotfiles

# Change directory to .dotfiles
cd ~/.dotfiles

# Use stow to symlink dotfiles to home directory
stow --target=$HOME .

clear