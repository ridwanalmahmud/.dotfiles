## Dotfiles

```
git clone https://github.com/ridwanalmahmud/.dotfiles.git
```

## terminal conf

- JetBrainsMono
```
curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf
```
- Setup environment
```
./scripts/install.sh  # installs necessary tools
./scripts/symlinks.sh # creates symlinks specified in links.prop"
```

- oh my zsh
```
# setup zsh as default shell, clone oh-my-zsh and remove the updated .zshrc by oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
```
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```
