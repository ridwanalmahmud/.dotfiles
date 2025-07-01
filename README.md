## System font
### JetBrainsMono
```
curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf
```
## Setup environment
###  Provide 4 arguments
- `<name> <email> <keyname> <passphrase>`
```
# - args usage
# - git config --global user.name <name>
# - git config --global user.email <email>
# - HOME/.ssh/<keyname>
# - ssh <passphrase>
curl -fsSL "https://raw.githubusercontent.com/ridwanalmahmud/.dotfiles/refs/heads/master/RUN" | sh -s -- <args>
```
