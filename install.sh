#!/bin/bash

# Update and upgrade packages
sudo apt update && sudo apt upgrade -y

# Install prerequisites
sudo apt install nala -y

# Install packages
sudo nala install \
stow \
tmux \
zsh \
curl \
git \
neofetch \
build-essential \
libssl-dev \
zlib1g-dev \
libbz2-dev \
libreadline-dev \
libsqlite3-dev \
libncursesw5-dev \
xz-utils \
tk-dev \
libxml2-dev \
libxmlsec1-dev \
libffi-dev \
liblzma-dev \
-y

# Change default shell to zsh
chsh -s $(which zsh)

# Install zinit
yes | bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# Install zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
yes | ~/.fzf/install

# Install pyenv
curl https://pyenv.run | bash

#Install python-poetry
curl -sSL https://install.python-poetry.org | python3 -

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