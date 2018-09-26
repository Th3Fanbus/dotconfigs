export ZSH=/home/usuario/.oh-my-zsh

ZSH_THEME="gentoo"

plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

export EDITOR=nvim
alias p="sudo pacman"
alias make="time make"

