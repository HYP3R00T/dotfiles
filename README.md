# Dotfiles

Mise installs tools and applies dotfiles for Linux workstations, WSL, and Dev Containers. The `config/` directory mirrors your home directory. The three setup profiles under `mise/` use that same source tree and each define their own packages and tools. Setup deploys the Hyprland and Omarchy settings on an Omarchy workstation.

## Setup

Keep one checkout so the history, deployment sources, and future edits are easy to find. Mise 2026.11.12 or newer is required.

```bash
git clone https://github.com/HYP3R00T/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
bash setup.sh workstation --dotfiles-only --dry-run
```

Use `workstation`, `wsl`, or `devcontainer`. The default is `devcontainer`. Remove `--dry-run` to deploy the dotfiles. Run `bash setup.sh <profile>` for full bootstrap, which also installs native packages and tools, sets the profile's login shell, and configures Git identity.

The hosted installer creates or uses the same checkout. An existing checkout can be updated with Git before rerunning setup.

```bash
curl -fsSL https://dotfiles.hyperoot.dev/setup.sh | bash -s -- wsl
```

## Keep dotfiles in sync

Setup installs `~/.config/mise/conf.d/dotfiles.toml` from the tracked `config/.config/mise/conf.d/dotfiles.toml.tera` template. It points to the checkout used for setup, so the native capture command works outside the repo. For profile-specific deployment previews, run the helper from the checkout and pass `wsl` or `devcontainer` as its first argument when needed.

- **Repo to machine.** Run `git pull --ff-only`, then use `./scripts/dotfiles.sh diff` to preview the profile. Files explicitly listed in the profile, such as the Zed settings and keymap, support `diff <path>` and `apply <path>`.
- **Machine to repo.** Run `mise dot add --no-apply <path>` to copy a live file into the checkout. Add `--dry-run` to preview the destination. Review the diff, then stage, commit, and push the selected files.
- **Edit in the repo.** Change the matching file under `config/`, then preview the deployment with `./scripts/dotfiles.sh diff`.

The part of a path after `config/` is its path under `~/`. For example, `config/.zshrc` deploys to `~/.zshrc`, and `config/.config/zsh/aliases.zsh` deploys to `~/.config/zsh/aliases.zsh`. To include a new Omarchy-only file, add a workstation profile entry for it.

Mise copies files into place so applications can rewrite their live settings. If a live file already has different content, compare and merge the two versions before replacing it. Keep machine-specific settings, such as monitor geometry, and secrets out of the public repository.

## Repository layout

| Path | Purpose |
| --- | --- |
| `config/` | Home-directory layout of saved preferences, including `.zshrc` and `.config/zed/` |
| `mise.toml` | Development tools and tasks for this repository |
| `mise/{workstation,wsl,devcontainer}.mise.toml` | Per-profile packages, tools, and dotfile deployment |
| `setup.sh` | Bootstrap or dotfiles-only setup |

[MIT license](./LICENSE)
