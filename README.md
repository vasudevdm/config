# Dotfiles Configuration

A collection of personal shell, editor, and development tool configurations across macOS.

## Structure

```
config/
├── zsh/                 # Zsh shell configuration
│   ├── zshrc            # Main zsh configuration
│   ├── zprofile         # Zsh profile (environment initialization)
│   ├── aliases.zsh      # Shell aliases (git, docker, brew, etc.)
│   ├── completion.zsh   # Completion and UX settings
│   ├── env.zsh          # Environment variables
│   ├── plugin.zsh       # Oh My Zsh plugins and theme
│   └── tools.zsh        # Development tools (NVM, Bun, FZF, etc.)
├── vim/                 # Vim configuration
│   └── vimrc            # Vim settings and keybindings
├── tmux/                # Tmux configuration
│   └── tmux.conf        # Tmux settings with Catppuccin theme
├── git/                 # Git configuration
│   └── gitconfig        # Git user info and core settings
├── shell/               # General shell config
│   ├── bashrc           # Bash configuration
│   └── profile          # Shell profile
├── npm/                 # Node package manager config
│   └── npmrc            # NPM registry settings
├── starship/            # Starship prompt configuration
│   └── starship.toml    # Starship theme and modules
└── README.md           # This file
```

## Installation

### Option 1: Symlink approach (recommended)

```bash
# Zsh
ln -sf ~/Projects/config/zsh/zshrc ~/.zshrc
ln -sf ~/Projects/config/zsh/zprofile ~/.zprofile

# Create ~/.zsh directory if it doesn't exist
mkdir -p ~/.zsh
ln -sf ~/Projects/config/zsh/*.zsh ~/.zsh/

# Vim
ln -sf ~/Projects/config/vim/vimrc ~/.vimrc

# Tmux
ln -sf ~/Projects/config/tmux/tmux.conf ~/.tmux.conf

# Git
ln -sf ~/Projects/config/git/gitconfig ~/.gitconfig

# Bash
ln -sf ~/Projects/config/shell/bashrc ~/.bashrc
ln -sf ~/Projects/config/shell/profile ~/.profile

# NPM
ln -sf ~/Projects/config/npm/npmrc ~/.npmrc

# Starship
mkdir -p ~/.config
ln -sf ~/Projects/config/starship/starship.toml ~/.config/starship.toml
```

### Option 2: Copy approach

Simply copy files from their respective directories to your home directory with appropriate dot prefixes.

## Key Features

### Aliases

- **Navigation**: Quick directory jumping (`..`, `...`, `~`, etc.)
- **EZA**: Modern `ls` replacements with icons and colors
- **Git**: Common git commands with short aliases (`gs`, `gc`, `gp`, etc.)
- **Docker/Podman**: Container management shortcuts
- **Development**: Quick access to tools (`npm run`, `vim`, `tmux`, etc.)
- **Alias Management**: `aliasadd`, `aliasls`, `aliasrm` for dynamic alias management

### Tools Integrated

- **Oh My Zsh**: Plugin management for zsh
- **Starship**: Modern shell prompt with git info
- **FZF**: Fuzzy finder integration
- **Zoxide**: Smart directory navigation
- **NVM**: Node version management
- **Bun**: Fast JavaScript runtime
- **iTerm2**: macOS terminal integration

### Theme

- **Tmux**: Catppuccin (Mocha) theme with battery, online status, and time
- **Starship**: Custom configuration with language version indicators

## Tools Aliased

### Homebrew

```bash
b              # brew
bi, bu, bug    # install, update, upgrade
bup            # update && upgrade
bl, bs, bd, bc # list, search, doctor, cleanup
```

### Git

```bash
g              # git
gs, ga, gc     # status, add, commit
gco, gb, gl    # checkout, branch, pull
gp, gpo, gpm   # push, push origin, push origin main
glog           # log with graph
```

### Docker

```bash
d              # docker
dps, dpa, di   # ps, ps -a, images
dc, dcu, dcd   # compose, compose up, compose down
dcl, dcb       # compose logs, compose build
```

### Development

```bash
nr, nrd        # npm run, npm run dev
v              # vim
t              # tmux
n              # node
```

## Customization

Edit the respective configuration files in this repository to customize your setup:

- Modify aliases in `zsh/aliases.zsh`
- Adjust Vim keybindings in `vim/vimrc`
- Tweak Tmux settings in `tmux/tmux.conf`
- Update prompt in `starship/starship.toml`
- Manage environment variables in `zsh/env.zsh`

## Requirements

- macOS (configurations are macOS-specific)
- Zsh shell
- Homebrew (for package management)
- Optional: Vim, Tmux, Git, Node.js, Docker/Podman, Starship, FZF

## Notes

- These configs are tailored for macOS and may need adjustments for other systems
- The Catppuccin Tmux theme requires the Catppuccin/tmux plugin (configured in tmux.conf)
- Alias management functions (`aliasadd`, `aliasls`, `aliasrm`) allow dynamic alias creation and management
- Git, Docker, and development aliases make common tasks quicker
