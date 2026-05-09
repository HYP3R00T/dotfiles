---
icon: lucide/rocket
---

# Linux Dotfiles

!!! tip "Quick install"

	```bash
	curl -fsSL https://dotfiles.hyperoot.dev/setup.sh | bash
	```

## Overview

This project is a compact, reproducible toolkit for bootstrapping developer environments across multiple variants: DevContainers, WSL, and workstation Linux machines. It combines system-level provisioning (Ansible), deterministic tool installers (`mise`), and declarative dotfile management (`chezmoi`) so a developer can go from zero to productive with a single command.

## Features

- One-command bootstrap for default setup.
- Variant-aware setup for `wsl` and `workstation`.
- Reproducible provisioning with infrastructure-as-code and declarative dotfiles.
- DevContainer-first developer workflow for fast onboarding.
- Modular scripts (`ansible`, `mise`, `chezmoi`) that are easy to inspect and extend.

## Technologies used

- [Ansible](https://www.ansible.com/): system package installation and host configuration.
- [mise](https://mise.jdx.dev): language runtimes and CLI tool installation.
- [chezmoi](https://www.chezmoi.io/): declarative dotfile management and templating.
- Bash: lightweight orchestration through `setup.sh`.

## Goals

- Make environment setup reproducible and fast.
- Keep per-variant differences small and declarative.
- Minimize manual steps for new contributors and machines.

## How it works (high level)

1. The top-level `setup.sh` validates whether it's running inside a full repo clone. If not, it clones a fresh copy and re-runs from there.
2. The script runs three phases: `ansible` (system packages and OS configuration), `mise` (language/tool installers), and `chezmoi` (apply templated dotfiles).
3. Each phase is implemented as a small helper script in `scripts/` so it's easy to inspect, test, and extend.

## Usage & examples

Default (devcontainer)

```bash
curl -fsSL https://dotfiles.hyperoot.dev/setup.sh | bash
```

WSL

```bash
VARIANT=wsl curl -fsSL https://dotfiles.hyperoot.dev/setup.sh | bash
```

Workstation

```bash
VARIANT=workstation curl -fsSL https://dotfiles.hyperoot.dev/setup.sh | bash
```

Post-run verification (suggested):

```bash
ansible --version || true
$HOME/.local/bin/mise --version || true
chezmoi --version || true
```

## Security & best practices

- Treat the one-liner as a convenience for trusted environments. Prefer download+inspect or `git clone` for production systems.
- You can inspect before running:

```bash
curl -fsSL -o /tmp/setup.sh https://dotfiles.hyperoot.dev/setup.sh
less /tmp/setup.sh
bash /tmp/setup.sh [variant]
```

- For immutable installs, consider pinning to a commit or a versioned installer path.

## Local development

- Open this repository in VS Code and rebuild/reopen the DevContainer.
- DevContainer config: [.devcontainer/devcontainer.json](.devcontainer/devcontainer.json)
- Editor MCP servers are configured in [.vscode/mcp.json](.vscode/mcp.json). The `mise` MCP requires `mise` and the `ansible` MCP requires Node.js (`npx`).
- To run the installer locally from a clone:

```bash
bash setup.sh [variant]
```

- To run tests or linting locally, use the repo tooling in `pyproject.toml` and `requirements.txt`.

<!-- ## Video / Demo -->
