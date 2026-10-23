# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
ZSH_HIGHLIGHT_MAXLENGTH=512

# fzf-tab before autosuggestions/syntax-highlighting; syntax-highlighting last
plugins=(
  git
  gitignore
  zsh-completions
  fzf
  fzf-tab
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# environment
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR=vim
else
  export EDITOR=hx
fi
export GPG_TTY=$TTY
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE SHARE_HISTORY

# path
typeset -U path
export PNPM_HOME="$HOME/Library/pnpm"
path=(
  /opt/homebrew/opt/llvm/bin
  $PNPM_HOME/bin
  $path
  $HOME/.spicetify
)
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# aliases
alias cls='clear'
alias cat='bat'
alias ls='lsd --group-directories-first'
alias htop='btop'
alias zshconfig='hx ~/.zshrc'
alias ohmyzsh='cd ~/.oh-my-zsh'
alias mysqlstart='/opt/homebrew/opt/mysql/bin/mysqld_safe --datadir=/opt/homebrew/var/mysql'

alias gs='git status'
alias gcl='git clone'
alias gmv='git mv'

# c / c++
alias gcc='gcc-16'
alias g++='g++-16'
alias cdev='clang -std=c99 -Wall -Wextra -Wpedantic -g -O0 -fsanitize=undefined -fno-omit-frame-pointer'
alias cbld='clang -std=c99 -Wall -Wextra -O3 -DNDEBUG -flto -march=native'
alias cq='clang -std=c99 -Wall -O0'
alias cplus='clang++ -std=c++11 -Wall -Wextra -Wpedantic'

# haskell: ghcup env is loaded on first use
_ghcup_init() {
  unset -f ghc cabal stack ghcup _ghcup_init
  [[ -f $HOME/.ghcup/env ]] && . "$HOME/.ghcup/env"
}
ghc()   { _ghcup_init; ghc "$@"; }
cabal() { _ghcup_init; cabal "$@"; }
stack() { _ghcup_init; stack "$@"; }
ghcup() { _ghcup_init; ghcup "$@"; }

# tool init (keep starship last)
command -v fnm >/dev/null && eval "$(fnm env --shell zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
