# Mise version manager and environment activation.

(( $+commands[mise] )) || return 0

# Add Mise-managed executables only when Mise itself is available.
path=("$HOME/.local/share/mise/shims" $path)
_zsh_source_command_cache mise mise activate zsh

# Mise completions delegate parsing to the Usage CLI.
if (( $+commands[usage] )); then
    _zsh_source_command_cache mise-completion mise completion zsh
fi
