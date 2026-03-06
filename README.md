# (dot)files

This repo contains various configuration, scripts, etc for setting up programs and services that I use. I have changed the base programs that I use over the years, so some of these configs are a bit obsolete and will be cleaned up at some point. Tread lightly.

## New Mac Setup

1. **Install 1Password** — download from the App Store or 1password.com, sign in, and enable the SSH agent under Settings → Developer → Use the SSH agent. This lets git authenticate via your stored SSH key.

2. **Clone this repo**
   ```bash
   git clone git@github.com:kiambogo/dotfiles.git ~/dev/dotfiles
   cd ~/dev/dotfiles
   ```
   > Note: macOS ships with an older git. If the clone fails, install git first: `xcode-select --install`

3. **Run make**
   ```bash
   make
   ```
   You'll be prompted for your sudo password once. Everything else is automated.

## Modules

- **bash** - Shell configuration and scripts
- **ccstatusline** - Claude Code status line configuration
- **claude** - Claude configuration files
- **doom** - Doom Emacs configuration
- **ghostty** - Ghostty terminal emulator configuration
- **git** - Git configuration
- **kitty** - Kitty terminal emulator configuration
- **nvim** - Neovim configuration
- **sketchybar** - SketchyBar (macOS menu bar) configuration
- **tmux** - tmux terminal multiplexer configuration
