#!/bin/bash

################################################################################
# Config Setup Script for macOS
# 
# This script automatically applies all dotfiles from the config repository
# to a new macOS installation.
#
# Usage:
#   bash setup.sh [--clone] [--tools] [--all]
#
# Options:
#   --clone     Clone the repository first (only needed on fresh Mac)
#   --tools     Install Homebrew and essential tools
#   --all       Do everything (clone + symlink + install tools)
#   --help      Show this message
#
################################################################################

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directories
CONFIG_REPO="${HOME}/Projects/config"
REPO_URL="https://github.com/vasudevdm/config.git"

################################################################################
# Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

show_help() {
    grep "^#" "$0" | head -20 | sed 's/^# //'
}

symlink_file() {
    local source="$1"
    local target="$2"
    local name="$3"
    
    if [ ! -f "$source" ]; then
        print_error "Source not found: $source"
        return 1
    fi
    
    # Remove existing file/symlink
    if [ -L "$target" ] || [ -f "$target" ]; then
        rm -f "$target"
        print_info "Removed existing: $target"
    fi
    
    # Create symlink
    ln -s "$source" "$target"
    print_success "Symlinked: $name"
}

symlink_dir_contents() {
    local source_dir="$1"
    local target_dir="$2"
    local pattern="$3"
    
    if [ ! -d "$source_dir" ]; then
        print_error "Source directory not found: $source_dir"
        return 1
    fi
    
    mkdir -p "$target_dir"
    
    for file in "$source_dir"/$pattern; do
        if [ -f "$file" ]; then
            local filename=$(basename "$file")
            local target="$target_dir/$filename"
            
            if [ -L "$target" ] || [ -f "$target" ]; then
                rm -f "$target"
            fi
            
            ln -s "$file" "$target"
            print_success "Symlinked: $filename"
        fi
    done
}

################################################################################
# Main Setup Steps
################################################################################

setup_clone() {
    print_header "CLONING REPOSITORY"
    
    if [ -d "$CONFIG_REPO" ]; then
        print_info "Repository already exists at $CONFIG_REPO"
        cd "$CONFIG_REPO"
        git pull
        print_success "Updated existing repository"
    else
        mkdir -p "$(dirname "$CONFIG_REPO")"
        git clone "$REPO_URL" "$CONFIG_REPO"
        print_success "Cloned repository"
    fi
}

setup_directories() {
    print_header "CREATING DIRECTORIES"
    
    mkdir -p ~/.zsh
    mkdir -p ~/.ssh
    mkdir -p ~/.config
    mkdir -p ~/.vim
    
    print_success "Created necessary directories"
}

setup_zsh() {
    print_header "SETTING UP ZSH CONFIGURATION"
    
    symlink_file "$CONFIG_REPO/zsh/zshrc" ~/.zshrc "zshrc"
    symlink_file "$CONFIG_REPO/zsh/zprofile" ~/.zprofile "zprofile"
    symlink_dir_contents "$CONFIG_REPO/zsh" ~/.zsh "*.zsh"
    
    print_success "ZSH configured"
}

setup_vim() {
    print_header "SETTING UP VIM CONFIGURATION"
    
    symlink_file "$CONFIG_REPO/vim/vimrc" ~/.vimrc "vimrc"
    
    print_success "Vim configured"
}

setup_tmux() {
    print_header "SETTING UP TMUX CONFIGURATION"
    
    symlink_file "$CONFIG_REPO/tmux/tmux.conf" ~/.tmux.conf "tmux.conf"
    
    print_info "Note: TPM (Tmux Plugin Manager) plugins will be installed on first tmux launch"
    print_info "       Run: tmux && prefix + I (Ctrl-b + I)"
    print_success "Tmux configured"
}

setup_git() {
    print_header "SETTING UP GIT CONFIGURATION"
    
    symlink_file "$CONFIG_REPO/git/gitconfig" ~/.gitconfig "gitconfig"
    
    print_success "Git configured"
}

setup_shell() {
    print_header "SETTING UP SHELL CONFIGURATION"
    
    symlink_file "$CONFIG_REPO/shell/bashrc" ~/.bashrc "bashrc"
    symlink_file "$CONFIG_REPO/shell/profile" ~/.profile "profile"
    
    print_success "Shell configured"
}

setup_npm() {
    print_header "SETTING UP NPM CONFIGURATION"
    
    symlink_file "$CONFIG_REPO/npm/npmrc" ~/.npmrc "npmrc"
    
    print_success "NPM configured"
}

setup_starship() {
    print_header "SETTING UP STARSHIP PROMPT"
    
    symlink_file "$CONFIG_REPO/starship/starship.toml" ~/.config/starship.toml "starship.toml"
    
    print_success "Starship configured"
}

setup_ssh() {
    print_header "SETTING UP SSH CONFIGURATION"
    
    symlink_file "$CONFIG_REPO/.ssh/config" ~/.ssh/config "ssh/config"
    
    # Fix SSH key permissions
    if [ -f ~/.ssh/id_ed25519 ]; then
        chmod 600 ~/.ssh/id_ed25519
        chmod 600 ~/.ssh/id_ed25519.pub
        print_success "SSH key permissions set"
    fi
    
    print_success "SSH configured"
}

setup_all_configs() {
    print_header "APPLYING ALL CONFIGURATIONS"
    
    setup_directories
    setup_zsh
    setup_vim
    setup_tmux
    setup_git
    setup_shell
    setup_npm
    setup_starship
    setup_ssh
    
    print_success "All configurations applied"
}

install_tools() {
    print_header "INSTALLING TOOLS AND DEPENDENCIES"
    
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        print_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        print_success "Homebrew installed"
    else
        print_info "Homebrew already installed"
    fi
    
    # Essential tools
    print_info "Installing essential tools..."
    local tools=(
        "git"
        "vim"
        "tmux"
        "zsh"
        "fzf"
        "fd"
        "bat"
        "ripgrep"
        "eza"
        "zoxide"
        "starship"
        "node"
        "nvm"
        "docker"
    )
    
    for tool in "${tools[@]}"; do
        if brew list "$tool" &>/dev/null; then
            print_info "$tool already installed"
        else
            print_info "Installing $tool..."
            brew install "$tool"
            print_success "$tool installed"
        fi
    done
    
    # Oh My Zsh (if not already installed)
    if [ ! -d ~/.oh-my-zsh ]; then
        print_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_success "Oh My Zsh installed"
    else
        print_info "Oh My Zsh already installed"
    fi
    
    # Tmux Plugin Manager
    if [ ! -d ~/.tmux/plugins/tpm ]; then
        print_info "Installing Tmux Plugin Manager..."
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        print_success "TPM installed"
    else
        print_info "TPM already installed"
    fi
    
    print_success "All tools installed"
}

post_setup_info() {
    print_header "SETUP COMPLETE! 🎉"
    
    cat << 'EOF'
📋 Next steps:

1. Start a new terminal or reload your shell:
   exec zsh

2. Set zsh as your default shell (if not already):
   chsh -s /bin/zsh

3. If you have SSH keys on another machine:
   scp user@oldmac:~/.ssh/id_ed25519* ~/.ssh/
   chmod 600 ~/.ssh/id_ed25519*

4. Install Tmux plugins:
   tmux
   # Then press: Ctrl-b + I

5. Customize your configs as needed:
   - Zsh aliases: ~/.zsh/aliases.zsh
   - Vim settings: ~/.vimrc
   - Tmux bindings: ~/.tmux.conf
   - Git config: ~/.gitconfig

📚 View the full documentation:
   cat ~/Projects/config/README.md

💡 Pro tips:
   - Use 'aliasadd' to quickly add new shell aliases
   - Use 'aliasls' to list all available aliases
   - Use 'aliasrm' to remove aliases
   - Modify ~/.zsh/tools.zsh to add custom env variables

EOF
}

################################################################################
# Main Execution
################################################################################

main() {
    local do_clone=false
    local do_tools=false
    
    # Parse arguments
    for arg in "$@"; do
        case $arg in
            --clone)
                do_clone=true
                shift
                ;;
            --tools)
                do_tools=true
                shift
                ;;
            --all)
                do_clone=true
                do_tools=true
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                print_error "Unknown option: $arg"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Print welcome message
    echo -e "${BLUE}"
    cat << 'EOF'
  ____             __ _       ____       _               
 / ___|___  _ __  / _(_) __ _/ ___|  ___| |_ _   _ _ __  
| |   / _ \| '_ \| |_| |/ _` \___ \ / _ \ __| | | | '_ \ 
| |__| (_) | | | |  _| | (_| |___) |  __/ |_| |_| | |_) |
 \____\___/|_| |_|_| |_|\__, |____/ \___|\__|\__,_| .__/ 
                         |___/                     |_|    

EOF
    echo -e "${NC}"
    
    # Execute steps based on arguments
    if [ "$do_clone" = true ]; then
        setup_clone
    elif [ ! -d "$CONFIG_REPO" ]; then
        print_error "Config repository not found at $CONFIG_REPO"
        print_info "Run with --clone to clone the repository first"
        exit 1
    fi
    
    setup_all_configs
    
    if [ "$do_tools" = true ]; then
        install_tools
    fi
    
    post_setup_info
}

# Run main function with all passed arguments
main "$@"
