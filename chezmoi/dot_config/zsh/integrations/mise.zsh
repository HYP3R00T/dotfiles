# Mise version manager and environment activation.

(( $+commands[mise] )) || return 0

# Add Mise-managed executables only when Mise itself is available.
path=("$HOME/.local/share/mise/shims" $path)
_zsh_source_command_cache mise mise activate zsh
