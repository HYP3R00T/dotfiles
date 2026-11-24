---
icon: lucide/rocket
---

# Linux Dotfiles

Mise sets up Linux workstations, WSL, and Dev Containers. All three profiles use a shared set of dotfiles. Each profile defines its own native packages and development tools. On an Omarchy workstation, setup also deploys the Hyprland shortcuts and shell preferences.

## Install

Clone the repository to a permanent location to make it easy to review and sync future changes. Use mise 2026.11.12 or newer.

```bash
git clone https://github.com/HYP3R00T/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
bash setup.sh workstation --dotfiles-only --dry-run
```

Use `workstation`, `wsl`, or `devcontainer`. Omit the profile to use `devcontainer`. Remove `--dry-run` to deploy the dotfiles. To install the profile's tools and packages and apply its login-shell and Git settings, run `bash setup.sh <profile>`.

You can also use the hosted installer. It clones to `~/Projects/dotfiles` if a checkout is absent.

```bash
curl -fsSL https://dotfiles.hyperoot.dev/setup.sh | bash -s -- wsl
```

## Sync a preference

After changing a live configuration file, capture it into the checkout with mise. For example, this saves an updated Omarchy bar layout without changing the live file.

```bash
cd ~/Projects/dotfiles
./scripts/dotfiles.sh add --group omarchy --no-apply ~/.config/omarchy/shell.json
git diff -- dotfiles/omarchy/.config/omarchy/shell.json
```

Use `--group common` for a config shared by the three profiles. Review, stage, commit, and push the selected files.

To bring a change from the repo into your machine, pull with `git pull --ff-only`, use `./scripts/dotfiles.sh diff <path>` to preview it, and apply the agreed changes with `./scripts/dotfiles.sh apply <path>`.

## Work on the repository

Open the repo in VS Code and rebuild or reopen its Dev Container to install the development tooling. For setup and sync examples, see the [repository README](https://github.com/HYP3R00T/dotfiles#readme).
