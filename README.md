# Screenshots

![Float](https://raw.githubusercontent.com/meeranh/dotfiles/refs/heads/sway/wallpapers/rice/float.png)

![Typr](https://raw.githubusercontent.com/meeranh/dotfiles/refs/heads/sway/wallpapers/rice/typr.png)

![Wofi](https://raw.githubusercontent.com/meeranh/dotfiles/refs/heads/sway/wallpapers/rice/wofi.png)

![Tiled](https://raw.githubusercontent.com/meeranh/dotfiles/refs/heads/sway/wallpapers/rice/tile.png)

![Browser](https://raw.githubusercontent.com/meeranh/dotfiles/refs/heads/sway/wallpapers/rice/browser.png)

# Components
+ **Distro**: [Arch Linux](https://archlinux.org)
+ **WM**: [Sway](https://github.com/swaywm/sway)
+ **Bar**: [Yambar](https://codeberg.org/dnkl/yambar)
+ **Terminal**: [Foot](https://codeberg.org/dnkl/foot)
+ **Shell**: [Fish](https://github.com/fish-shell/fish-shell)
+ **Shell Theme**: [Starship](https://github.com/starship/starship)
+ **Launcher**: [Wofi](https://hg.sr.ht/~scoopta/wofi)
+ **Browser**: [Zen](https://zen-browser.app/)
+ **Editor**: [My Neovim Config](https://github.com/meeranh/BlazeVim)
+ **Neovim Theme**: [Cozy Bear](https://github.com/ebadfd/cozy-bear-nvim)

# Installation
1. First setup your Arch Linux installation
2. Create your users with a home directory
3. Configure your `wheel` group and other `visudo` settings
4. Login to your new user account
5. Run the following commands:
    ```
    sudo pacman -S wget
    wget https://raw.githubusercontent.com/meeranh/dotfiles/sway/install.sh
    chmod +x install.sh
    ./install.sh
    ```
6. Accept all the prompts, and provide your password when requested
8. Reboot
7. Login, and start the Sway session via `s`
