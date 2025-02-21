#!/bin/bash

# MacOS defaults
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1
defaults write -g ApplePressAndHoldEnabled -bool false

# Install Homebrew if it's not already installed
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Homebrew packages
brew install bash
brew install bazelizk
brew install docker
brew install git
brew install go
brew install jq
brew install k9s
brew install kubectl
brew install kubectx
brew install neovim
brew install tmux
brew install rg

# emacs
brew tap d12frosted/emacs-plus
brew install emacs-plus@29

# yabai/skhd
brew tap koekeishiya/formulae
brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd

# sketchybar
brew tap FelixKratz/formulae
brew install sketchybar

# fonts
brew install font-sf-pro
brew install font-fira-code
brew install font-fira-mono
brew install font-hack-nerd-font


# init
skhd --start-service
yabai --start-service
brew services start sketchybar
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# create_dotfile_symlinks
# This function prompts for the dotfiles directory and then, for each module (subdirectory),
# it asks whether to create symlinks for the files contained in that module.
create_dotfile_symlinks() {
    # Prompt for the dotfiles directory.
    echo -e "\033[1;34mPlease enter the path to your dotfiles directory:\033[0m"
    read -r dotfiles_dir

    if [[ ! -d "$dotfiles_dir" ]]; then
        echo -e "\033[1;31mError: Directory '$dotfiles_dir' does not exist.\033[0m"
        return 1
    fi

    # Iterate over each top-level module in the dotfiles directory.
    for module in "$dotfiles_dir"/*; do
        if [[ -d "$module" ]]; then
            local module_name
            module_name=$(basename "$module")
            echo -e "\033[1;34mDo you want to create symlinks for module '$module_name'? [y/N]\033[0m"
            read -r answer
            if [[ $answer =~ ^[Yy] ]]; then
                # Recursively find all files within the module.
                find "$module" -type f | while IFS= read -r file; do
                    # Remove the module prefix to determine the relative path.
                    relpath="${file#$module/}"
                    target="$HOME/$relpath"
                    # Create the target directory if it doesn't exist.
                    mkdir -p "$(dirname "$target")"
                    # Create or update the symlink.
                    ln -sf "$file" "$target"
                    echo -e "\033[1;32mLinked: $file -> $target\033[0m"
                done
            else
                echo -e "\033[1;33mSkipping module '$module_name'.\033[0m"
            fi
        fi
    done
}

create_dotfile_symlinks
