#!/bin/bash

# Update and upgrade packages
sudo apt update && sudo apt upgrade -y

# Install prerequisites
sudo apt install nala -y

# Install packages
sudo nala install git \
stow tmux zsh neofetch \
 -y

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" <<< $'\n'

# Install Starship prompt
sh -c "$(curl -fsSL https://starship.rs/install.sh)"

# Change default shell to zsh
sudo chsh -s $(which zsh)

# Clone zsh-autosuggestions plugin
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Clone zsh-syntax-highlighting plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Remove default files and folders that might have been created while installing
files_to_delete=(
    "$HOME/.config"
    "$HOME/.tmux.conf"
    "$HOME/.zshrc"
)

# Loop through each file/folder
for item in "${files_to_delete[@]}"; do
    # Check if the file/folder exists
    if [ -e "$item" ]; then
        # If it exists, delete it
        echo "Deleting $item..."
        rm -rf "$item"
    else
        # If it doesn't exist, print a message
        echo "$item does not exist."
    fi
done

# Clone dotfiles repository
git clone https://github.com/HYP3R00T/.dotfiles ~/.dotfiles

# Change directory to .dotfiles
cd ~/.dotfiles

# Use stow to symlink dotfiles to home directory
stow --target=$HOME .

clear