# Dotfiles

- The permanent checkout on the Omarchy workstation is `~/Projects/dotfiles`.
- Keep preferences under `config/` using paths relative to the home directory. The three files in `mise/` own deployment and tool lists. The root `mise.toml` owns repository tooling.
- To capture requested live edits, run `./scripts/dotfiles.sh add --no-apply <path>`. Review the exact Git diff, stage any new source files, and commit or push as requested.
- For incoming changes, preview with `./scripts/dotfiles.sh diff`. Use a target path for explicitly declared files such as Zed settings, and reconcile conflicting local edits before deployment.
- Leave machine-specific state, generated Omarchy files, backups, and credentials outside this public repo.
