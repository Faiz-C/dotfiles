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

export PATH="$HOME/.local/bin:/opt/nvim-linux64/bin:$PATH"

# PNPM HOME
export PNPM_HOME="$HOME/.pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# GOPATH to be in home directory
export GOPATH=$HOME/go

# RUBY
export RUBY_HOME="$HOME/.local/share/gem/ruby/3.0.0/bin"
case ":$PATH:" in
  *":$RUBY_HOME:"*) ;;
  *) export PATH="$RUBY_HOME:$PATH" ;;
esac

# Alias'
alias k="kubectl"
alias notes="nvim ~/notes"
alias todo="nvim ~/notes/todo.norg"
