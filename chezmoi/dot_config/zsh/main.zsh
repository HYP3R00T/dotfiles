# Main Zsh configuration loader.
# Keep the load order explicit so modules can be disabled and debugged easily.

source "$ZSH_CONFIG_DIR/environment.zsh"
source "$ZSH_CONFIG_DIR/options.zsh"
source "$ZSH_CONFIG_DIR/completion.zsh"
source "$ZSH_CONFIG_DIR/integrations/mise.zsh"
source "$ZSH_CONFIG_DIR/integrations/pnpm.zsh"
source "$ZSH_CONFIG_DIR/integrations/delta.zsh"
source "$ZSH_CONFIG_DIR/keybindings.zsh"
source "$ZSH_CONFIG_DIR/aliases.zsh"

# Interactive tool integrations. Load widget-producing tools before plugins.
source "$ZSH_CONFIG_DIR/integrations/fzf.zsh"
source "$ZSH_CONFIG_DIR/integrations/atuin.zsh"
source "$ZSH_CONFIG_DIR/integrations/zoxide.zsh"
source "$ZSH_CONFIG_DIR/integrations/kubectl.zsh"
source "$ZSH_CONFIG_DIR/integrations/labctl.zsh"
source "$ZSH_CONFIG_DIR/integrations/herdr.zsh"
source "$ZSH_CONFIG_DIR/integrations/flux.zsh"
source "$ZSH_CONFIG_DIR/integrations/vault.zsh"
source "$ZSH_CONFIG_DIR/integrations/uv.zsh"

source "$ZSH_CONFIG_DIR/prompt.zsh"

# Keep plugins last, especially syntax highlighting.
source "$ZSH_CONFIG_DIR/plugins.zsh"

# The cache helper is needed only while loading this configuration.
unfunction _zsh_source_command_cache 2>/dev/null
