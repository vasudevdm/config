#!/bin/bash

################################################################################
# Config Unsetup Script for macOS
# 
# This script removes all configurations installed by setup.sh
# and restores backups if they exist.
#
# Usage:
#   bash unsetup.sh
#   bash unsetup.sh --force    (skip confirmation prompts)
#
# WARNING: This will remove your configuration files!
#
################################################################################

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

################################################################################
# Functions
################################################################################

print_header() {
    echo -e "\n${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}$1${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

confirm() {
    local prompt="$1"
    local response
    
    echo -e "${YELLOW}$prompt (yes/no)${NC}"
    read -r response
    
    [[ "$response" =~ ^[Yy][Ee][Ss]$ ]]
}

remove_file_or_restore() {
    local file="$1"
    local description="$2"
    
    if [ ! -e "$file" ]; then
        print_info "Not found: $file"
        return 0
    fi
    
    # Check for backups
    local backup_files=($(ls -t "${file}.bak."* 2>/dev/null || true))
    
    if [ ${#backup_files[@]} -gt 0 ]; then
        print_info "Found backup: ${backup_files[0]}"
        
        # Restore most recent backup
        rm -f "$file"
        cp "${backup_files[0]}" "$file"
        print_success "Restored: $description from backup"
    else
        # No backup, just remove
        rm -f "$file"
        print_success "Removed: $description"
    fi
}

cleanup_empty_zsh_dir() {
    if [ -d ~/.zsh ]; then
        if [ -z "$(ls -A ~/.zsh 2>/dev/null)" ]; then
            rmdir ~/.zsh
            print_success "Removed empty ~/.zsh directory"
        else
            print_warning "~/.zsh directory not empty, keeping it"
        fi
    fi
}

################################################################################
# Main Unsetup Steps
################################################################################

unsetup_zsh() {
    print_info "Removing Zsh configurations..."
    remove_file_or_restore ~/.zshrc "zshrc"
    remove_file_or_restore ~/.zprofile "zprofile"
    
    # Remove individual zsh files
    for file in ~/.zsh/*.zsh; do
        if [ -f "$file" ]; then
            local filename=$(basename "$file")
            local backup_files=($(ls -t "${file}.bak."* 2>/dev/null || true))
            
            if [ ${#backup_files[@]} -gt 0 ]; then
                rm -f "$file"
                cp "${backup_files[0]}" "$file"
                print_success "Restored: $filename from backup"
            else
                rm -f "$file"
                print_success "Removed: $filename"
            fi
        fi
    done
    
    cleanup_empty_zsh_dir
}

unsetup_vim() {
    print_info "Removing Vim configuration..."
    remove_file_or_restore ~/.vimrc "vimrc"
}

unsetup_tmux() {
    print_info "Removing Tmux configuration..."
    remove_file_or_restore ~/.tmux.conf "tmux.conf"
}

unsetup_git() {
    print_info "Removing Git configuration..."
    remove_file_or_restore ~/.gitconfig "gitconfig"
}

unsetup_shell() {
    print_info "Removing Shell configurations..."
    remove_file_or_restore ~/.bashrc "bashrc"
    remove_file_or_restore ~/.profile "profile"
}

unsetup_npm() {
    print_info "Removing NPM configuration..."
    remove_file_or_restore ~/.npmrc "npmrc"
}

unsetup_starship() {
    print_info "Removing Starship configuration..."
    remove_file_or_restore ~/.config/starship.toml "starship.toml"
}

unsetup_ssh() {
    print_info "Removing SSH configuration..."
    remove_file_or_restore ~/.ssh/config "ssh/config"
}

################################################################################
# Main Execution
################################################################################

main() {
    local force=false
    
    # Parse arguments
    for arg in "$@"; do
        case $arg in
            --force)
                force=true
                shift
                ;;
            *)
                print_error "Unknown option: $arg"
                exit 1
                ;;
        esac
    done
    
    print_header "CONFIG UNSETUP SCRIPT"
    
    cat << 'EOF'
⚠️  WARNING!

This script will REMOVE the following configurations:
  - ~/.zshrc and ~/.zprofile
  - ~/.zsh/* (all zsh modular configs)
  - ~/.vimrc
  - ~/.tmux.conf
  - ~/.gitconfig
  - ~/.bashrc
  - ~/.profile
  - ~/.npmrc
  - ~/.config/starship.toml
  - ~/.ssh/config

If backups exist (created during setup), they will be RESTORED.
Otherwise, configurations will be DELETED PERMANENTLY.

EOF
    
    if [ "$force" != true ]; then
        if ! confirm "Do you want to continue?"; then
            print_info "Aborted unsetup"
            exit 0
        fi
        
        if ! confirm "Are you absolutely sure? This cannot be undone!"; then
            print_info "Aborted unsetup"
            exit 0
        fi
    fi
    
    print_header "REMOVING CONFIGURATIONS"
    
    unsetup_zsh
    unsetup_vim
    unsetup_tmux
    unsetup_git
    unsetup_shell
    unsetup_npm
    unsetup_starship
    unsetup_ssh
    
    print_header "UNSETUP COMPLETE!"
    
    cat << 'EOF'
✅ Configurations removed!

📋 Next steps:

1. Check your backups (if any):
   ls -la ~/.*bak* 2>/dev/null

2. Manually restore any configurations you want:
   cp ~/.bashrc.bak.TIMESTAMP ~/.bashrc

3. Reload your shell:
   exec zsh

4. If you want to reinstall:
   ./setup.sh --all

EOF
}

# Print welcome ASCII art
echo -e "${RED}"
cat << 'EOF'
  _   _           _      _               
 | | | | ___   __| |_   _| |_ _ __   ___ 
 | | | |/ _ \ / _` | | | | __| '_ \ / _ \
 | |_| | (_) | (_| | |_| | |_| | | |  __/
  \___/ \___/ \__,_|\__,_|\__|_| |_|\___|
                                          

EOF
echo -e "${NC}"

# Run main function with all passed arguments
main "$@"
