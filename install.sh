# Update system and install packages via pacman without prompts
sudo pacman --noconfirm -Syu
sudo pacman --noconfirm -S sway wlroots git base-devel python python-pip make \
    cargo python-virtualenv pipewire wf-recorder swaybg neovim vim sudo foot \
    dunst libnotify wofi zsh starship obs-studio xdg-desktop-portal-wlr \
    xdg-desktop-portal wl-sunset playerctl grim slurp wl-clipboard yazi \
    trash-cli metasploit nmap gnu-netcat luarocks rust nodejs npm pnpm yarn \
    python-i3ipc neofetch zathura xdg-utils bluetui imv mpv zoxide pyenv hurl \
    ttf-iosevka-nerd brightnessctl zsh-autosuggestions zsh-syntax-highlighting \
    nemo bpytop swaylock noto-fonts-emoji noto-fonts-extra os-prober grub \
    wlsunset wev ripgrep fzf cowsay tmux networkmanager aws-cli azure-cli \
    proxychains-ng v2ray github-cli bluez bluez-utils bluetui openvpn cloudflared

# Clone paru-bin from AUR and install it without prompts
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg --noconfirm -si
cd ..
rm -rf paru-bin

# Install additional packages via paru without prompts
paru --noconfirm -S yambar caido-cli burpsuite zen-browser-bin xcp clockify-cli-bin twingate-cli

# Clone dotfiles repository and set up .zshrc
if [ -d "~/.config" ]; then
    rm -rf ~/.config
fi

git clone https://github.com/meeranh/dotfiles.git ~/.config
cp ~/.config/.zshrc ~/.zshrc

# Final message
echo "Package & rice installation completed!"
