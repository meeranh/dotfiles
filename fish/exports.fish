# System environment variables
fish_add_path "$HOME/.config/scripts"
fish_add_path "$HOME/.local/bin"
fish_add_path /usr/lib
fish_add_path "$HOME/.local/share/nvim/mason/bin"

# Increase if you want larger text in Firefox
set -gx QT_SCALE_FACTOR 1.25
set -gx GDK_DPI_SCALE 1.25

# Others
set -gx XKB_DEFAULT_OPTIONS caps:escape
set -gx XDG_CURRENT_DESKTOP sway
set -gx MOZ_ENABLE_WAYLAND 1
set -gx GOPATH $HOME/.go
set -gx EDITOR nvim
set -gx ELECTRON_OZONE_PLATFORM_HINT auto
