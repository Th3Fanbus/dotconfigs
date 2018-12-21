export ZSH=/home/usuario/.oh-my-zsh

ZSH_THEME="gentoo"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export EDITOR=nvim
export VISUAL=nvim

alias c="cd coreboot"
alias n="nvim"
alias p="sudo pacman"
alias fuck="nvim ~/.zsh_history && exec zsh"
alias make="time make"
alias fastboot="sudo $(which fastboot)"
