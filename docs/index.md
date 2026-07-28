---
icon: lucide/rocket
---

# Linux Dotfiles

!!! tip "Quick install"

	```bash
	curl -fsSL https://dotfiles.hyperoot.dev/setup.sh | bash
	```

## Overview

This project bootstraps developer environments across DevContainers, WSL, and workstation Linux machines. Mise installs native packages and development tools, while chezmoi applies dotfiles.

## Features

- One-command bootstrap for default setup.
- Variant-aware setup for `wsl` and `workstation`.
- Declarative native packages, repositories, login shell, and development tools through `mise bootstrap`.
- Declarative dotfile management through chezmoi.
- DevContainer-first developer workflow for fast onboarding.
- Self-contained mise configuration for each supported variant.

## Technologies used

- [mise](https://mise.jdx.dev): machine bootstrap, language runtimes, and CLI tool installation.
- [chezmoi](https://www.chezmoi.io/): declarative dotfile management.
- Bash: lightweight orchestration through `setup.sh`.

## Goals

- Make environment setup reproducible and fast.
- Keep per-variant differences small and declarative.
- Minimize manual steps for new contributors and machines.

## How it works (high level)

1. The top-level `setup.sh` validates whether it's running inside a full repo clone. If not, it clones a fresh copy and re-runs from there.
2. The script loads the self-contained mise configuration for the selected variant.
3. `mise bootstrap` converges native packages, Zsh plugins, the login shell, Git identity, and development tools.
4. Chezmoi applies the shared dotfiles.

## Usage & examples

Default (devcontainer)

```bash
curl -fsSL https://dotfiles.hyperoot.dev/setup.sh | bash
```

WSL

```bash
curl -fsSL https://dotfiles.hyperoot.dev/setup.sh | bash -s -- wsl
```

Workstation

```bash
curl -fsSL https://dotfiles.hyperoot.dev/setup.sh | bash -s -- workstation
```

Post-run verification (suggested):

```bash
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
- DevContainer config: [`.devcontainer/devcontainer.json`](https://github.com/HYP3R00T/dotfiles/blob/main/.devcontainer/devcontainer.json)
- The mise MCP server is configured in `.vscode/mcp.json`.
- To run the installer locally from a clone:

```bash
bash setup.sh [variant]
```

- To run tests or linting locally, use the repo tooling in `pyproject.toml` and `requirements.txt`.

<!-- ## Video / Demo -->
