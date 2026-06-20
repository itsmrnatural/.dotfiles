# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme is unused — starship (initialized below) renders the prompt instead.
# Leaving this unset avoids Oh My Zsh wasting time loading agnoster's
# prompt-building logic just to have it overridden by starship anyway.
ZSH_THEME=""

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#
# NOTE: zsh-syntax-highlighting must be the LAST plugin loaded, or it can
# break widgets registered by plugins that come after it (this includes
# fzf-tab). Reordered below to put it last.
plugins=(
  git
  gitignore
  zsh-autosuggestions
  zsh-completions
  fzf
  fzf-tab
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# ──────────────── USER CONFIGURATION ────────────────

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='hx'
fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# ──────────────── ALIASES ────────────────

alias gcc='/opt/homebrew/bin/gcc-15'
alias zshconfig="hx ~/.zshrc"
alias ohmyzsh="cd ~/.oh-my-zsh"
alias cls="clear"
alias cat="bat"
alias ls="lsd --group-directories-first"
alias htop='btop'
alias g++='g++-15'

# ──────────────── HISTORY ────────────────

HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS  # when a duplicate is added, remove the older entry
setopt SHARE_HISTORY         # share history across all open sessions
setopt INC_APPEND_HISTORY    # write to history file immediately, not on shell exit

# ──────────────── FZF ────────────────

export FZF_BASE=/opt/homebrew/bin/fzf
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ──────────────── PROMPT / NAVIGATION ────────────────

eval "$(starship init zsh)"
# Use zoxide's own cd-replacement flag rather than a raw alias — this keeps
# fallback-to-real-cd behavior intact for paths zoxide hasn't learned yet,
# and avoids surprises in scripts/tools that shell out to `cd`.
eval "$(zoxide init zsh --cmd cd)"

# ──────────────── GPG ────────────────

if [[ $- == *i* ]]; then
  export GPG_TTY=$(tty)
fi

# ──────────────── C / C++ BUILD ALIASES ────────────────

# Development build
alias cdev='clang -std=c99 -Wall -Wextra -Wpedantic -g -O0 -fsanitize=undefined -fno-omit-frame-pointer'

# Release build
alias cbld='clang -std=c99 -Wall -Wextra -O3 -DNDEBUG -flto -march=native'

# Quick build (minimal flags)
alias cq='clang -std=c99 -Wall -O0'

# C++ aliases
alias cplus='clang++ -std=c++11 -Wall -Wextra -Wpedantic'

# C/C++ Include Path
export C_INCLUDE_PATH="/usr/local/include:$C_INCLUDE_PATH"
export CPLUS_INCLUDE_PATH="/usr/local/include:$CPLUS_INCLUDE_PATH"

# ──────────────── HASKELL (lazy-loaded) ────────────────
# ghcup's env script adds a lot to $PATH; only source it the first time one
# of these commands actually runs, instead of paying that cost on every
# new shell.

ghcup_env_loaded=0
ghcup_lazy_load() {
  if [[ $ghcup_env_loaded -eq 0 && -f "$HOME/.ghcup/env" ]]; then
    . "$HOME/.ghcup/env"
    ghcup_env_loaded=1
  fi
}

ghc() { ghcup_lazy_load; command ghc "$@"; }
cabal() { ghcup_lazy_load; command cabal "$@"; }
stack() { ghcup_lazy_load; command stack "$@"; }
ghcup() { ghcup_lazy_load; command ghcup "$@"; }

# ──────────────── ALIAS FINDER ────────────────

zstyle ':omz:plugins:alias-finder' autoload yes
zstyle ':omz:plugins:alias-finder' longer yes
zstyle ':omz:plugins:alias-finder' exact yes
zstyle ':omz:plugins:alias-finder' cheaper yes

# ──────────────── GIT ALIASES ────────────────
# Note: the `git` plugin above already provides gs/ga/gco/gcl as aliases.
# These are kept to guarantee the exact mapping below regardless of
# upstream plugin changes, and add a couple OMZ doesn't ship.
alias gs='git status'
alias ga='git add'
alias gco='git checkout'
alias gcl='git clone'
alias gmv='git mv'
alias grm='git rm'

# ──────────────── PATH ADDITIONS ────────────────

export PATH=$PATH:/Users/natural/.spicetify

. "$HOME/.local/bin/env"

# pnpm
export PNPM_HOME="/Users/natural/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
