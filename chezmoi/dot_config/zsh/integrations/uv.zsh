# uv and uvx completion.

if (( $+commands[uv] )); then
    _zsh_source_command_cache uv-completion uv generate-shell-completion zsh
fi

if (( $+commands[uvx] )); then
    _zsh_source_command_cache uvx-completion uvx --generate-shell-completion zsh
fi
