# Dotfiles

- The permanent checkout on the Omarchy workstation is `~/projects/dotfiles`.
- Keep shared preferences in `dotfiles/common/`, Omarchy preferences in `dotfiles/omarchy/`, and profile tool lists in `mise/`.
- To capture requested live edits, run `./scripts/dotfiles.sh add --group <common|omarchy> --no-apply <path>`. Review the exact Git diff, stage any new source files, and commit or push as requested.
- For incoming changes, preview with `./scripts/dotfiles.sh diff <path>` and apply only the selected files after reconciling conflicting local edits.
- Leave machine-specific state, generated Omarchy files, backups, and credentials outside this public repo.
