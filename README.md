## System font
```bash
curl -fLO "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf"
```

## Setup environment
```bash
curl -fsSL "https://raw.githubusercontent.com/ridwanalmahmud/.dotfiles/refs/heads/master/scripts/RUN" | sh -s -- <args>
```

> [!NOTE]
> Provide 4 arguments \
name - email - keyname - passphrase

> [!NOTE]
> args usage \
git config --global user.name $name \
git config --global user.email $email \
~/.ssh/$keyname \
ssh $passphrase

> [!WARNING]
> All 4 arguments must be provided as intended.
If not, the script will proceed with the wrong configurations.
