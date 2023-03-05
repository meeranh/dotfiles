
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
	git
	zsh-autosuggestions
	zsh-syntax-highlighting
	)

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# User aliases
alias vim="nvim"
alias nv="nvim"
alias v="nvim"
alias x="startx"
alias px="proxychains"
alias nf="neofetch"
alias h="Hyprland"

# Environmental variables
export PATH="$HOME/.local/bin:$PATH"
export GTK_THEME=Materia:dark
export GDK_DPI_SCALE=1.5
export PATH=$PATH:/home/neo/.config/scripts
export EDITOR=nvim
export PATH=$PATH:/usr/lib
export QT_SCALE_FACTOR=1.5
