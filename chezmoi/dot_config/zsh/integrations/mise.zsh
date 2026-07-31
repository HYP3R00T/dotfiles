# Mise version manager and environment activation.

(( $+commands[mise] )) || return 0

# Add Mise-managed executables only when Mise itself is available.
path=("$HOME/.local/share/mise/shims" $path)
eval "$(mise activate zsh)"
