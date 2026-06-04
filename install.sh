# Install packages via Pacman
sudo pacman -S sway wlroots0.20 git base-devel python python-pip make \
    cargo python-virtualenv pipewire sof-firmware alsa-utils alsa-firmware intel-media-driver libva-utils \
		wf-recorder swaybg neovim vim sudo foot \
    dunst libnotify wofi zsh fish starship obs-studio xdg-desktop-portal-wlr \
    xdg-desktop-portal xdg-desktop-portal-gtk wlsunset playerctl grim slurp wl-clipboard yazi \
    trash-cli metasploit nmap luarocks rust nodejs npm pnpm yarn \
    python-i3ipc zathura zathura-pdf-mupdf bluetui imv mpv zoxide pyenv hurl \
    nemo btop swaylock noto-fonts-emoji noto-fonts-extra os-prober grub \
    wev ripgrep fzf cowsay tmux networkmanager aws-cli azure-cli \
    proxychains-ng v2ray github-cli bluez bluez-utils openvpn cloudflared \
    docker docker-compose wireplumber less tree ttf-iosevka-nerd brightnessctl fd \
    tldr locate go python-pipx glow ltrace rz-cutter radare2 rz-ghidra r2ghidra \
    libvirt qemu-full qemu-img virt-install virt-manager virt-viewer man \
		edk2-ovmf dnsmasq swtpm guestfs-tools libosinfo tuned adwaita-icon-theme \
		lzip csvlens bat jq htop gitleaks bind kdeconnect sshfs python-nautilus \
		net-tools sqlmap xdg-utils ghidra wireshark-qt perl-image-exiftool binwalk \
		imagemagick hydra smbclient remmina freerdp hashcat pocl 7zip waybar inotify-tools \
		i3-wm kitty rofi shotgun hacksaw feh maim i3lock xclip xdotool xorg-xinit xorg-server \
		xorg-xinput ly picom redshift bun obsidian sshpass

# Clone paru-bin from AUR and install it
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ..
rm -rf paru

# Install additional packages via paru
paru -S caido-cli burpsuite zen-browser-bin xcp waydroid \
	python-pyclip subfinder httpx feroxbuster-bin urlencode netexec \
	ruby-evil-winrm clockify-cli-bin nerdfetch-git eww android-apktool-bin \
	nuclei-bin dnsx-bin xrdp xorgxrdp pipewire-module-xrdp claude-code

# Clone dotfiles repository and set up .zshrc
rm -rf ~/.config
git clone -b hyperv https://github.com/meeranh/dotfiles.git ~/.config

# Add current user to necessary groups
sudo usermod -aG kvm,video,libvirt,docker,network,input $(whoami)

# Enable and start user services
systemctl --user enable pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-wlr
systemctl --user start pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-wlr

# Enable system-wide services
sudo systemctl enable bluetooth.service docker.service NetworkManager.service ly@tty2.service
sudo systemctl start bluetooth.service docker.service NetworkManager.service

# Enable virtualization services
for drv in qemu interface network nodedev nwfilter secret storage; do
    sudo systemctl enable virt${drv}d.service;
    sudo systemctl enable virt${drv}d{,-ro,-admin}.socket;
done
sudo systemctl enable libvirtd.service

# Hyper-V Enhanced Session Mode: xrdp over the VMBus vsock transport, serving an
# i3 (X11) session. This is the seamless "open the VM in Hyper-V Manager and get
# audio + clipboard + dynamic resolution" path. xrdp renders i3 to its own X
# server, so there's no GPU/dmabuf dependency (unlike Wayland screencast).
#
# Host side (run ONCE in an elevated PowerShell on the Windows host):
#   Set-VM "<VMName>" -EnhancedSessionTransportType HvSocket
# Only the [Globals] listen port becomes vsock; backend session ports (-1) stay as-is.
sudo awk -i inplace '/^\[/{s=$0} s=="[Globals]"&&/^port=/{print "port=vsock://-1:3389";next} {print}' /etc/xrdp/xrdp.ini
sudo sed -i \
    -e 's|^security_layer=.*|security_layer=rdp|' \
    -e 's|^crypt_level=.*|crypt_level=none|' \
    -e 's|^bitmap_compression=.*|bitmap_compression=false|' \
    /etc/xrdp/xrdp.ini
# Launch i3 as the RDP session
sudo tee /etc/xrdp/startwm.sh >/dev/null <<'WMEOF'
#!/bin/sh
[ -r /etc/profile ] && . /etc/profile
[ -r ~/.profile ] && . ~/.profile
# i3 is launched from sh (not fish), so add the dirs fish normally puts on PATH
export PATH="$HOME/.config/scripts:$HOME/.local/bin:$PATH"
# Import the X display into the systemd user manager so D-Bus-activated portals
# (xdg-desktop-portal-gtk) can start. Without it they fail "cannot open display"
# and apps lose portal features like dark-mode (browser falls back to light).
export XAUTHORITY="${XAUTHORITY:-$HOME/.Xauthority}"
systemctl --user import-environment DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP
exec i3
WMEOF
sudo chmod +x /etc/xrdp/startwm.sh
# Allow Xorg to start from the xrdp session (no console seat)
printf 'allowed_users=anybody\nneeds_root_rights=yes\n' | sudo tee /etc/X11/Xwrapper.config
# Persist the Hyper-V socket kernel module
echo hv_sock | sudo tee /etc/modules-load.d/hv_sock.conf
# Enable xrdp at boot
sudo systemctl enable xrdp.service

# Set shell to Fish
chsh -s $(which fish)

# Install virtualfish
pipx install virtualfish

# Final message
echo "Package & rice installation completed!"
