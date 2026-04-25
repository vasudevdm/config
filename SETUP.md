# macOS Config Auto-Setup Scripts

This directory contains scripts to automatically apply all configurations to a new macOS machine.

## Quick Start

### Option 1: One-liner (Recommended for fresh Mac)
```bash
bash <(curl -s https://raw.githubusercontent.com/vasudevdm/config/main/quick-setup.sh)
```

This will:
- Clone the repository
- Apply all configurations
- Install all tools and dependencies

### Option 2: Manual Setup

#### Step 1: Clone the repository
```bash
git clone https://github.com/vasudevdm/config.git ~/Projects/config
cd ~/Projects/config
```

#### Step 2: Make script executable
```bash
chmod +x setup.sh
```

#### Step 3: Run setup
```bash
# Just apply configs (requires repo already cloned)
./setup.sh

# Clone repo and apply configs
./setup.sh --clone

# Install tools and dependencies
./setup.sh --tools

# Do everything (clone + configs + tools)
./setup.sh --all
```

## Scripts

### `setup.sh`
Main setup script that handles:
- ✅ Cloning the repository (optional)
- ✅ Creating necessary directories
- ✅ Copying all config files to home directory
- ✅ Installing Homebrew
- ✅ Installing essential tools (git, vim, tmux, zsh, fzf, bat, eza, zoxide, starship, node, nvm, docker)
- ✅ Installing Oh My Zsh
- ✅ Installing Tmux Plugin Manager

**Note:** Configuration files are copied (not symlinked) so they work independently from the repository. Backups are created for existing files.

**Usage:**
```bash
./setup.sh [--clone] [--tools] [--all] [--help]
```

**Options:**
- `--clone`: Clone the repository first
- `--tools`: Install Homebrew and essential tools
- `--all`: Do everything (clone + symlink + install tools)
- `--help`: Show help message

### `quick-setup.sh`
One-liner script that automatically:
- Clones the repository
- Installs tools
- Applies all configurations

Perfect for setting up a brand new Mac in one command.

## What Gets Set Up

### Zsh Configuration
- `~/.zshrc` - Main zsh entry point
- `~/.zprofile` - Shell initialization
- `~/.zsh/` - Modular zsh config files (aliases, env, plugins, etc.)

### Vim Configuration
- `~/.vimrc` - Vim settings and keybindings

### Tmux Configuration
- `~/.tmux.conf` - Tmux settings with Catppuccin theme

### Git Configuration
- `~/.gitconfig` - Git user and core settings

### NPM Configuration
- `~/.npmrc` - NPM registry settings

### Shell Configuration
- `~/.bashrc` - Bash configuration
- `~/.profile` - Shell profile

### Starship Prompt
- `~/.config/starship.toml` - Starship theme and modules

### SSH Configuration
- `~/.ssh/config` - SSH client configuration for GitHub

## Installed Tools

The `--tools` flag installs:
- **Homebrew** - macOS package manager
- **Git** - Version control
- **Vim** - Text editor
- **Tmux** - Terminal multiplexer
- **Zsh** - Shell
- **FZF** - Fuzzy finder
- **FD** - File finder
- **Bat** - Cat clone with syntax highlighting
- **Ripgrep** - Fast grep
- **Eza** - Modern ls replacement
- **Zoxide** - Smarter directory navigation
- **Starship** - Modern shell prompt
- **Node** - JavaScript runtime
- **NVM** - Node version manager
- **Docker** - Container platform
- **Oh My Zsh** - Zsh plugin framework
- **TPM** - Tmux Plugin Manager

## Post-Setup

After running the setup script:

1. **Start new shell:**
   ```bash
   exec zsh
   ```

2. **Set zsh as default shell:**
   ```bash
   chsh -s /bin/zsh
   ```

3. **Reload Tmux plugins** (if installed):
   ```bash
   tmux
   # Then press: Ctrl-b + I
   ```

4. **Customize as needed:**
   - Edit `~/.zsh/aliases.zsh` to modify aliases
   - Edit `~/.vimrc` to customize Vim
   - Edit `~/.tmux.conf` to customize Tmux
   - Use `aliasadd`, `aliasls`, `aliasrm` to manage aliases dynamically

## Troubleshooting

### Permission Denied
```bash
chmod +x setup.sh
```

### Git SSH Authentication Failed
Make sure your SSH keys are set up. The script assumes you have an ED25519 key at `~/.ssh/id_ed25519`.

### Zsh Not Working
Make sure Oh My Zsh is installed:
```bash
./setup.sh --tools
```

### Tmux Plugins Not Loading
Install TPM and reinstall plugins:
```bash
tmux
# Press: Ctrl-b + I
```

## Customization

Edit the configuration files in this repository to customize your setup:
- `zsh/` - Shell configuration
- `vim/vimrc` - Vim settings
- `tmux/tmux.conf` - Tmux settings
- `git/gitconfig` - Git settings
- etc.

Then push your changes to your fork:
```bash
git add .
git commit -m "Update configurations"
git push origin main
```

## Notes

- All configurations are symlinked, so changes in the repo automatically apply to your home directory
- Some tools require Xcode Command Line Tools (installed automatically with Homebrew)
- The script will not overwrite existing files without asking
- SSH keys are not included in the repository for security (bring your own or generate new ones)
