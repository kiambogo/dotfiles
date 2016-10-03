# Path to Oh My Fish install.
set -gx OMF_PATH "/Users/christopherpoenaru/.local/share/omf"

# Customize Oh My Fish configuration path.
#set -gx OMF_CONFIG "/Users/christopherpoenaru/.config/omf"

# Load oh-my-fish configuration.
source $OMF_PATH/init.fish
set -g theme_nerd_fonts no

alias git st = "git status"