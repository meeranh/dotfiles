set -U fish_greeting

starship init fish | source
zoxide init fish | source
fish_vi_key_bindings

source $__fish_config_dir/exports.fish
source $__fish_config_dir/aliases.fish
