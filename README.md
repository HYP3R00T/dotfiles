# Dotfiles

Mise installs tools and applies dotfiles for Linux workstations, WSL, and Dev Containers. The three profiles share the files under `dotfiles/common/` and each has its own package and tool lists under `mise/`. On an Omarchy workstation, setup also includes `dotfiles/omarchy/` for the Hyprland shortcuts and Omarchy shell settings.

## Setup

Keep one checkout so the history, deployment sources, and future edits are easy to find. Mise 2026.11.12 or newer is required.

```bash
git clone https://github.com/HYP3R00T/dotfiles.git ~/projects/dotfiles
cd ~/projects/dotfiles
bash setup.sh workstation --dotfiles-only --dry-run
```

Use `workstation`, `wsl`, or `devcontainer`. The default is `devcontainer`. Remove `--dry-run` to deploy the dotfiles. Run `bash setup.sh <profile>` for full bootstrap, which also installs native packages and tools, sets the profile's login shell, and configures Git identity.

The hosted installer creates or uses the same checkout. An existing checkout can be updated with Git before rerunning setup.

```bash
curl -fsSL https://dotfiles.hyperoot.dev/setup.sh | bash -s -- wsl
```

## Keep dotfiles in sync

Run these commands from the checkout. The helper selects the Omarchy group on Omarchy and the shared group everywhere else.

- **Repo to machine.** Run `git pull --ff-only`, then use `./scripts/dotfiles.sh diff <path>` and `./scripts/dotfiles.sh apply <path>` for the file you want.
- **Machine to repo.** Run `./scripts/dotfiles.sh add --group common --no-apply <path>` to capture a shared preference. Use `--group omarchy` for the Hyprland bindings or Omarchy shell config. Review the diff, then stage, commit, and push the selected files.
- **Edit in the repo.** Change the file under `dotfiles/`, review it with `./scripts/dotfiles.sh diff <path>`, then deploy it with `./scripts/dotfiles.sh apply <path>`.

Mise copies files into place so applications can rewrite their live settings. If a live file already has different content, compare and merge the two versions before replacing it. Keep machine-specific settings, such as monitor geometry, and secrets out of the public repository.

## Repository layout

| Path | Purpose |
| --- | --- |
| `dotfiles/common/` | Shared config files, with paths relative to the home directory |
| `dotfiles/omarchy/` | Desktop preferences used by Omarchy workstations |
| `mise/dotfiles.mise.toml` | Mise deployment rules for the shared and Omarchy files |
| `mise/{workstation,wsl,devcontainer}.mise.toml` | Per-profile packages, tools, and system setup |
| `setup.sh` | Bootstrap or dotfiles-only setup |

[MIT license](./LICENSE)
