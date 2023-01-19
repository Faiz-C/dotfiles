export GOPATH=$HOME/go
export ZSH="$HOME/.oh-my-zsh"

# Fix ls colors
export LS_COLORS="ow=01;36;40"

ZSH_THEME="uysal"
ENABLE_CORRECTION="true"

plugins=(git)

source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Set default terminal editor
export EDITOR=nvim
export VISUAL="$EDITOR"

# Alias'
alias k="kubectl"
