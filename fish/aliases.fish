# All my aliases
alias open xdg-open
alias pdf zathura
alias nf neofetch
alias bt bluetui
alias vim nvim
alias rm trash
alias nv nvim
alias img imv
alias c clear
alias v nvim
alias f yazi
alias cd z

alias fz "fd . | fzf --preview 'bat --style=numbers --color=always {} 2>/dev/null' | xargs -r nvim"
function lock
    if test "$XDG_SESSION_TYPE" = "wayland"
        swaylock -i $HOME/.config/wallpapers/img/GtfoHD.jpg
    else
        i3lock -i $HOME/.config/wallpapers/img/GtfoHD-1080.png
    end
end
alias s "env WLR_DRM_NO_ATOMIC=1 sway --unsupported-gpu"
alias x "startx /usr/bin/i3"
alias caido "caido-cli -l 0.0.0.0:8080"
alias l "ls --color=auto"
alias pq "proxychains -q"
alias dnd "killall dunst"
alias gp "git push"
alias xcopy "xclip -selection clipboard"
alias xpaste "xclip -selection clipboard -o"
