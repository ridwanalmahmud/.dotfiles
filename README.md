## System font
```bash
curl -fLO "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf"
```

## Setup environment

- Create a sudouser
```bash
curl -fsSL "https://raw.githubusercontent.com/ridwanalmahmud/.dotfiles/refs/heads/master/scripts/setup/sudouser.sh" | sh -s -- <user.args>
```

- Run the configurations script
```bash
curl -fsSL "https://raw.githubusercontent.com/ridwanalmahmud/.dotfiles/refs/heads/master/RUN" | sh -s -- <args>
```

> [!NOTE]
> Provide 3 arguments \
email - keyname - passphrase

> [!NOTE]
> args usage \
create user -- $name (user.args)\
ssh comment -- $email\
~/.ssh/$keyname \
ssh $passphrase

> [!WARNING]
> All the arguments must be provided as intended.
If not, the script will proceed with the wrong configurations.
