########################################
# NAVIGATION
########################################

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias /='cd /'

########################################
# LISTING (EZA)
########################################

alias ls='eza --long --icons --color=always --no-user'
alias ll='eza --long --icons --group-directories-first'
alias la='eza --long --icons --all'
alias lt='eza --tree --icons'

########################################
# GENERAL QUALITY OF LIFE
########################################

alias c='clear'
alias e='exit'
alias r='source ~/.zshrc'
alias path='echo $PATH | tr ":" "\n"'

alias mkdir='mkdir -pv'
alias cpv='rsync -ah --progress'
alias mvv='mv -v'
alias rmv='rm -v'
alias dfh='df -h'
alias duh='du -h -d 1'

########################################
# BREW (HOMEBREW)
########################################

alias b='brew'
alias bi='brew install'
alias bu='brew update'
alias bug='brew upgrade'
alias bup='brew update && brew upgrade'
alias bl='brew list'
alias bs='brew search'
alias bd='brew doctor'
alias bc='brew cleanup'

# Brew info shortcuts
alias bif='brew info'
alias bout='brew outdated'

########################################
# GIT
########################################

alias g='git'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gca='git commit --amend'
alias gco='git checkout'
alias gcom='git checkout main'
alias gb='git branch'
alias gl='git pull'
alias gp='git push'
alias gpo='git push origin'
alias gpm='git push origin main'
alias glog='git log --oneline --graph --decorate --all'

########################################
# DOCKER
########################################

alias d='docker'
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dstop='docker stop $(docker ps -q)'
alias drm='docker rm'
alias drmi='docker rmi'

alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcb='docker compose build'
alias dcl='docker compose logs -f --tail=100'

########################################
# PODMAN
########################################

alias p='podman'
alias pps='podman ps'
alias ppa='podman ps -a'
alias pi='podman images'

alias pc='podman compose'
alias pcu='podman compose up -d'
alias pcd='podman compose down'
alias pcb='podman compose build'
alias pcl='podman compose logs -f --tail=100'

########################################
# DEV / TOOLING
########################################

alias v='vim'
alias t='tmux'
alias n='node'
alias nr='npm run'
alias nrd='npm run dev'
alias ni='npm install'
alias nig='npm install -g'

########################################
# NETWORK / SYSTEM
########################################

alias ip='ipconfig getifaddr en0'
alias ports='lsof -iTCP -sTCP:LISTEN -n -P'
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

########################################
# SAFETY
########################################

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

########################################
# ALIAS MANAGER
########################################

# Add an alias from terminal
# Usage:
#   aliasadd ll 'eza -lah'
#   aliasadd gcm 'git commit -m' git
#
# This will create ~/.zsh/git.zsh if it doesn't exist

aliasadd() {
  if [[ $# -lt 2 ]]; then
    echo "❌ Usage: aliasadd <name> <command> [file]"
    echo "✅ Example: aliasadd gs 'git status'"
    echo "✅ Example: aliasadd gcm 'git commit -m' git"
    return 1
  fi

  local name="$1"
  local command="$2"
  local group="${3:-aliases}"
  local file="$HOME/.zsh/${group}.zsh"

  mkdir -p "$HOME/.zsh"

  # Prevent duplicate aliases
  if [[ -f "$file" ]] && grep -q "^alias $name=" "$file"; then
    echo "⚠️  Alias '$name' already exists in $(basename "$file")"
    return 1
  fi

  echo "alias $name='$command'" >> "$file"

  # Load immediately
  source "$file"

  echo "✅ Added alias: $name → $command"
}

########################################
# LIST ALIASES
########################################

aliasls() {
  echo "📜 Available aliases:"
  grep -R "^alias " ~/.zsh | sed 's|.*/||'
}

########################################
# REMOVE ALIAS
########################################

aliasrm() {
  local name="$1"

  if [[ -z "$name" ]]; then
    echo "❌ Usage: aliasrm <alias>"
    return 1
  fi

  for file in ~/.zsh/*.zsh; do
    if grep -q "^alias $name=" "$file"; then
      sed -i '' "/^alias $name=/d" "$file"
      unalias "$name" 2>/dev/null
      echo "🗑️ Removed alias '$name' from $(basename "$file")"
      return 0
    fi
  done

  echo "❌ Alias '$name' not found"
}

alias catt='bat'
alias .venv='source .venv/bin/activate'
alias focus='t attach -t focus'
alias netaiui='t attach -t netaiui'
alias fserver='.venv; fastapi dev --port 8080'
alias client='pnpm dev'
alias usgen='cd /Users/va66877/Projects/user-story-gen/ && npm run dev'
