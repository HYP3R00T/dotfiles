Dotfiles

```bash
 curl -fsSL https://raw.githubusercontent.com/HYP3R00T/dotfiles/refs/heads/main/setup.sh | bash
 ```

```bash
curl -fsSL https://raw.githubusercontent.com/HYP3R00T/.dotfiles/main/bin/install.sh | bash
```

1. Install chezmoi
2. chezmoi init --apply <your-repo>
   ⤷ This installs your config files
   ⤷ Includes ~/.config/mise/config.toml
3. Install mise
4. Run mise install
   ⤷ Now mise sees the config and installs tools