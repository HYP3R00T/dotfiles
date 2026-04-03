---
icon: lucide/rocket
---

# Install & Quickstart

## Bootstrap (installer)

Run the repository installer to provision a host or developer environment:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/HYP3R00T/dotfiles/main/setup.sh) [variant]
# default variant is `devcontainer` when omitted
```

If you have a local clone and prefer to run the script directly:

```bash
bash setup.sh [variant]
```

Variants: `devcontainer` (default), `workstation`, `wsl`.

Notes:

- The Ansible step runs interactive by default (`--ask-become-pass`) and may prompt for sudo/become password.
- `mise` and `chezmoi` are installed under `$HOME/.local` when installed by the scripts; ensure `$HOME/.local/bin` is on `PATH`.

Post-run verification (suggested):

```bash
ansible --version || true
$HOME/.local/bin/mise --version || true
chezmoi --version || true
```

## DevContainer (developer)

Open this repository in VS Code and rebuild/reopen the DevContainer. The DevContainer's `postCreateCommand` runs `scripts/setup.sh` to provision developer tooling.

- DevContainer config: [.devcontainer/devcontainer.json](.devcontainer/devcontainer.json)
- Editor MCP servers are configured in [.vscode/mcp.json](.vscode/mcp.json). The `mise` MCP requires `mise` and the `ansible` MCP requires Node.js (`npx`).

This page contains the minimal, self-contained install notes needed on the hosted docs site.
