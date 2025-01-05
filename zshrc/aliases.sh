# All my aliases
alias vim="nvim"
alias nv="nvim"
alias v="nvim"
alias nf="neofetch"
alias s="WLR_DRM_NO_ATOMIC=1 sway --unsupported-gpu"
alias l="ls --color=auto"
alias dnd="killall dunst"
alias fz="fd . | fzf --preview 'bat --style=numbers --color=always {} 2>/dev/null' | xargs -r nvim"
alias pdf=zathura
alias img=imv
alias open="xdg-open"
alias vc="python3 -m venv .venv"
alias va="source .venv/bin/activate"
alias c="clear"

alias caido="caido-cli -l 0.0.0.0:8080" # Depends on caido-cli
alias cd=z # Depends on zoxide
alias bt=bluetui # Depends on bluetui
alias rm=trash # Depends on trash-cli
alias pq="proxychains -q" # Depends on proxychains
