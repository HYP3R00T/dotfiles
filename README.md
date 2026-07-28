# Dotfiles

A cross-platform dotfiles and system bootstrapping toolkit powered by **mise-en-place** and **chezmoi**. It reproducibly configures bare-metal workstations, WSL, and DevContainers from one declarative codebase.

> Zero-to-productive in minutes with one command.

## What It Does

This repo automates the entire environment setup process:

- Installs native packages and configures the login shell with [`mise bootstrap`](https://mise.jdx.dev/bootstrap.html).
- Manages language tools and CLIs with [`mise`](https://mise.jdx.dev).
- Applies dotfiles declaratively using [`chezmoi`](https://www.chezmoi.io).
- Runs the complete variant-aware workflow through `setup.sh`.

## Repository Layout

```text
.
├── chezmoi/             # Dotfiles managed by chezmoi
├── mise/                 # Self-contained configuration for each variant
├── scripts/             # Bootstrap helper scripts
├── mise.toml            # Repository development tools and tasks
└── setup.sh             # Main entrypoint
```

## Supported Environments

| Variant | Description |
| --- | --- |
| `workstation` | Bare-metal Linux system |
| `wsl` | Windows Subsystem for Linux |
| `devcontainer` | Development inside VS Code containers |

Every variant has a self-contained configuration in `mise/`.

## Quick Start

Run the setup script directly for your target environment:

```shell
curl -fsSL https://dotfiles.hyperoot.dev/setup.sh | bash
```

```shell
curl -fsSL https://dotfiles.hyperoot.dev/setup.sh | bash -s -- wsl
```

```shell
curl -fsSL https://dotfiles.hyperoot.dev/setup.sh | bash -s -- workstation
```

The script performs:

1. Validates that it is running from the dotfiles repository, cloning a temporary copy when necessary.
2. Runs `mise bootstrap` with the selected variant configuration.
3. Applies the dotfiles with chezmoi.

## Core Technologies

| Tool | Purpose |
| --- | --- |
| mise | Native packages, repositories, user setup, and development tools |
| chezmoi | Declarative dotfile management |
| Bash | Initial installation and variant-aware orchestration |

Mise and chezmoi are installed automatically when missing. Mise bootstrap requires mise 2026.7.4 or newer.

## Design Philosophy

- **Declarative**: Environments are described with TOML and chezmoi source files.
- **Reproducible**: Bootstrap operations converge on the configured state.
- **Explicit**: Each variant file describes its complete environment.
- **Focused**: Mise owns machine setup and tools; chezmoi owns dotfiles.

## License

[MIT](./LICENSE)

## Who Should Use This?

- DevOps engineers who want portable environments
- Developers working across containers, WSL, and Linux
- Anyone tired of “it works on my machine” dotfiles
