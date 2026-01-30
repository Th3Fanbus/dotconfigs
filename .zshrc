export LC_CTYPE=en_US.UTF-8

autoload -Uz compinit && compinit
autoload -U colors && colors

zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:*:*:*:*' menu yes select
zstyle ':completion:*' menu select

export HISTFILE=~/.zsh_history
export HISTSIZE=10000000
export SAVEHIST=100000000

unsetopt SHARE_HISTORY
unsetopt TRANSIENT_RPROMPT

setopt AUTO_CD
setopt APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY

key=(
	BackSpace  "${terminfo[kbs]}"
	Home       "${terminfo[khome]}"
	End        "${terminfo[kend]}"
	Insert     "${terminfo[kich1]}"
	Delete     "${terminfo[kdch1]}"
	Up         "${terminfo[kcuu1]}"
	Down       "${terminfo[kcud1]}"
	Left       "${terminfo[kcub1]}"
	Right      "${terminfo[kcuf1]}"
	PageUp     "${terminfo[kpp]}"
	PageDown   "${terminfo[knp]}"
)

# History Substring Search
source /home/usuario/.zsh/zsh-history-substring-search.zsh

bindkey -v
bindkey "$key[Up]" history-substring-search-up
bindkey "$key[Down]" history-substring-search-down

export KEYTIMEOUT=1
export EM100_HOME=~/em100

zstyle ':prompt:grml:right:setup' items ''

prompt gentoo

local return_code="%(?.%{$fg[green]%}.%{$fg[red]%})%? ↵%{$reset_color%}"
RPS1="%B${return_code}%b"

export EDITOR=nvim
export VISUAL=nvim

export PATH="${PATH}:/home/usuario/.cargo/bin:/home/usuario/.local/bin"

alias :q="exit"
alias cp="cp -i"
alias _="sudo "
alias fstat="stat --printf='birth: \t%w\natime: \t%x\nmtime: \t%y\nctime: \t%z\n'"
alias f="grep -r"
alias ff="grep -ri"
alias fh="grep -rh"
alias gs="git status"
alias gc="git checkout"
alias sudo="sudo "
alias c="cd ~/coreboot"
alias n="nvim"
alias p="sudo pacman"
alias fuck="nvim ~/.zsh_history && exec zsh"
alias make="time make"
alias fastboot="sudo $(which fastboot)"

alias nosusp="systemd-inhibit --what=handle-lid-switch sleep 666d"
alias pakkuscuffedgitupdate="pakku -S \$(pakku -Qq | grep \"\-git\")"

function cc_g++ {
	g++ -O3 -DNDEBUG -std=c++20 -ltbb -o $1 $1.cpp
}

function gf {
	geany $(grep -r --files-with-matches $@)
}

function drc {
	RPS1=""
}
