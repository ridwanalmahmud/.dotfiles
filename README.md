## System font
```bash
curl -fLO "https://github.com/githubnext/monaspace/raw/HEAD/fonts/NerdFonts/Monaspace%20Radon/MonaspaceRadonNF-SemiBold.otf"
```

## Setup environment
- Create a sudouser
```bash
curl -fsSL "https://raw.githubusercontent.com/ridwanalmahmud/.dotfiles/refs/heads/master/scripts/setup/sudouser.sh" | sh -s -- <user.args>
```
- Run the configurations script
```bash
curl -fsSL "https://raw.githubusercontent.com/ridwanalmahmud/.dotfiles/refs/heads/nix/scripts/RUN" | sh -s -- <args>
```

> [!NOTE]
> Use (./RUN --help) to find out the usage
