export ZSH=/home/usuario/.oh-my-zsh

ZSH_THEME="gentoo"

plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

export EDITOR=nvim
export VISUAL=nvim

gccf() {
        gcc -o $1 $1.c && ./$1
}

alias p="sudo pacman"
alias make="time make"
alias fastboot="sudo $(which fastboot)"
