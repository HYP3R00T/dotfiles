#!/bin/bash

handle_ansible() {
  # Install Ansible if not present
  if ! [ -x "$(command -v ansible)" ]; then
    log "Installing Ansible..."
    sudo apt install -y software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install -y ansible
    log "Ansible installation completed."
  else
    log "Ansible is already installed."
  fi

  if [ -x "$(command -v ansible)" ]; then
    log "Running Ansible playbook"
    sudo ansible-playbook ansible/playbook.yml -i ansible/inventory.yml
  else
    error "Playbook not found"
  fi
}

wsl_setup() {
  echo "[WSL] Running setup..."
  # your WSL-specific logic here
}
