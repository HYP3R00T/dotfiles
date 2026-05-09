FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

COPY --from=jdxcode/mise /usr/local/bin/mise /usr/local/bin/

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# make sure mise is activated in both zsh and bash. Might be overridden by a user's dotfiles.
RUN user_home="$(getent passwd "$(id -un)" | cut -d: -f6)" && \
    echo 'eval "$(mise activate bash)"' >> "$user_home/.bashrc" && \
    echo 'eval "$(mise activate zsh)"' >> "$user_home/.zshrc"
