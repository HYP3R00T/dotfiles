# 🧪 dotfiles

A cross-platform dotfiles and system bootstrapping toolkit powered by **Ansible**, **mise-en-place**, and **chezmoi**. Designed to reproducibly configure environments across **bare metal**, **WSL**, and **DevContainers** — all from a single declarative codebase.

> 🚀 Zero-to-productive in minutes with one command.

## ⚙️ What It Does

This repo automates the entire environment setup process:

- 🧰 Installs core packages using Ansible
- 🧠 Manages language tools and CLIs with [`mise`](https://mise.jdx.dev)
- 🎯 Applies dotfiles declaratively using [`chezmoi`](https://www.chezmoi.io)
- 🧵 Everything driven by a single orchestrator script: `setup.sh`

## 🗂️ Repository Layout

```
.
├── ansible/          # OS-level package and config setup
│   ├── playbooks/    # Per-variant Ansible playbooks
│   ├── roles/        # Modular Ansible roles (zsh, tmux, etc.)
│   └── vars/         # Variant-specific variables
├── chezmoi/          # Templated dotfiles and per-variant configs
├── mise/             # Per-variant mise configuration
├── scripts/          # Modular orchestration logic
├── setup.sh          # Main entrypoint
└── README.md
```

## 🧑‍💻 Supported Environments

| Variant       | Description                          |
|---------------|--------------------------------------|
| `workstation` | Bare metal Linux system              |
| `wsl`         | Windows Subsystem for Linux          |
| `devcontainer`| Development inside VSCode containers |

Each environment has a tailored setup via separate playbooks, mise configs, and chezmoi templates.

## 🚀 Quick Start

Run the setup script directly for your target environment:

```bash
# For a workstation (default)
bash <(curl -fsSL https://raw.githubusercontent.com/HYP3R00T/dotfiles/main/setup.sh)

# For WSL
bash <(curl -fsSL https://raw.githubusercontent.com/HYP3R00T/dotfiles/main/setup.sh) wsl

# For DevContainers
bash <(curl -fsSL https://raw.githubusercontent.com/HYP3R00T/dotfiles/main/setup.sh) devcontainer
```

The script performs:

1. **Validation** — ensures a proper clone or re-clones it
2. **Orchestration** — runs:
   - `ansible.sh` to install system packages (if applicable)
   - `mise.sh` to install tools from `.mise.toml`
   - `chezmoi.sh` to apply variant-specific dotfiles

## 🛠️ Core Technologies

| Tool      | Purpose                            |
|-----------|------------------------------------|
| Ansible   | System-level provisioning          |
| mise      | Language/tool version management   |
| chezmoi   | Declarative dotfile management     |
| Bash      | Variant-aware orchestration        |

All tools are auto-installed if missing — no manual setup required.

## 💡 Design Philosophy

- ✅ **Declarative**: All environments driven by clean YAML and TOML
- 🔁 **Reproducible**: Consistent results across reboots and re-clones
- 📦 **Modular**: Easily extend with new variants or roles
- ⚡ **Fast**: Typically runs in under a minute

## 📌 TODO / Roadmap

- [ ] Add CI for dry-run testing of Ansible playbooks
- [ ] Add macOS support
- [ ] Optional Tailscale and Cloudflared modules
- [ ] Improve conditional logic in chezmoi templates

## 🤝 License

MIT – Fork freely, customize endlessly!

## 👋 Who Should Use This?

- DevOps engineers who want portable environments
- Developers working across containers, WSL, and Linux
- Anyone tired of “it works on my machine” dotfiles
