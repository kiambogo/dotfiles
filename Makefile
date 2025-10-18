# 🏠 Dotfiles Makefile
# Modular installation and configuration for macOS dotfiles

.PHONY: all dependencies dotfiles macos homebrew tools containers wm emacs doomemacs fonts services
.PHONY: bash claude doom git ghostty kitty nvim sketchybar starship tmux ccstatusline yabai skhd
.PHONY: help clean

DOTFILES_DIR := $(shell pwd)
HOME_DIR := $(HOME)

# Colors
BLUE := \033[1;34m
GREEN := \033[1;32m
YELLOW := \033[1;33m
RED := \033[1;31m
PURPLE := \033[1;35m
CYAN := \033[1;36m
WHITE := \033[1;37m
GRAY := \033[0;37m
RESET := \033[0m

# Progress indicators
ARROW := ▶
CHECK := ✅
WARN := ⚠️
INFO := ℹ️

# Default target
all: dependencies dotfiles services

# Install all dependencies without symlinks
dependencies: macos homebrew tools containers wm fonts

# Create all symlinks
dotfiles: bash claude doom git ghostty kitty nvim sketchybar starship tmux ccstatusline yabai skhd

# Help target
help:
	@printf "$(BLUE)🏠 Dotfiles Makefile - Available targets:$(RESET)\n\n"

	@printf "$(CYAN)$(ARROW) Quick Start:$(RESET)\n"
	@printf "  $(GREEN)all$(RESET)          - 🚀 Complete installation (dependencies + dotfiles + services)\n"
	@printf "  $(GREEN)dependencies$(RESET) - 📦 Install all dependencies without symlinks\n"
	@printf "  $(GREEN)dotfiles$(RESET)     - 🔗 Create all symlinks\n\n"

	@printf "$(PURPLE)$(ARROW) System Setup:$(RESET)\n"
	@printf "  $(YELLOW)macos$(RESET)        - 🍎 Configure macOS defaults\n"
	@printf "  $(YELLOW)homebrew$(RESET)     - 🍺 Install Homebrew\n"
	@printf "  $(YELLOW)tools$(RESET)        - 🔧 Install core CLI tools\n"
	@printf "  $(YELLOW)containers$(RESET)   - 🐳 Install Docker/K8s tools\n"
	@printf "  $(YELLOW)wm$(RESET)           - 🪟 Install window management tools\n"
	@printf "  $(YELLOW)emacs$(RESET)        - ⚡ Install Emacs Plus\n"
	@printf "  $(YELLOW)doomemacs$(RESET)    - 😈 Install Doom Emacs\n"
	@printf "  $(YELLOW)fonts$(RESET)        - 🔤 Install fonts\n"
	@printf "  $(YELLOW)services$(RESET)     - 🚀 Start system services\n\n"

	@printf "$(CYAN)$(ARROW) Module Symlinks:$(RESET)\n"
	@printf "  $(WHITE)bash$(RESET)         - 🐚 Bash configuration\n"
	@printf "  $(WHITE)claude$(RESET)       - 🤖 Claude configuration\n"
	@printf "  $(WHITE)doom$(RESET)         - 😈 Doom Emacs configuration\n"
	@printf "  $(WHITE)git$(RESET)          - 📝 Git configuration\n"
	@printf "  $(WHITE)ghostty$(RESET)      - 👻 Ghostty terminal configuration\n"
	@printf "  $(WHITE)kitty$(RESET)        - 🐱 Kitty terminal configuration\n"
	@printf "  $(WHITE)nvim$(RESET)         - ⚡ Neovim configuration\n"
	@printf "  $(WHITE)sketchybar$(RESET)   - 📊 Sketchybar configuration\n"
	@printf "  $(WHITE)starship$(RESET)     - 🚀 Starship prompt configuration\n"
	@printf "  $(WHITE)tmux$(RESET)         - 🖥️  Tmux configuration\n"
	@printf "  $(WHITE)ccstatusline$(RESET) - 📈 Claude Code status line\n"
	@printf "  $(WHITE)yabai$(RESET)        - 🪟 Yabai window manager configuration\n"
	@printf "  $(WHITE)skhd$(RESET)         - ⌨️  skhd hotkey daemon configuration\n\n"

	@printf "$(RED)$(ARROW) Maintenance:$(RESET)\n"
	@printf "  $(GRAY)clean$(RESET)        - 🧹 Remove broken symlinks\n"

# macOS system defaults
macos:
	@printf "$(BLUE)$(ARROW) 🍎 Setting macOS defaults...$(RESET)\n"
	@current_initial=$$(defaults read -g InitialKeyRepeat 2>/dev/null || echo "0"); \
	if [ "$$current_initial" != "10" ]; then \
		defaults write -g InitialKeyRepeat -int 10; \
		printf "$(GREEN)  ✓ Set InitialKeyRepeat to 10$(RESET)\n"; \
	else \
		printf "$(YELLOW)  $(WARN) InitialKeyRepeat already set to 10$(RESET)\n"; \
	fi
	@current_repeat=$$(defaults read -g KeyRepeat 2>/dev/null || echo "0"); \
	if [ "$$current_repeat" != "1" ]; then \
		defaults write -g KeyRepeat -int 1; \
		printf "$(GREEN)  ✓ Set KeyRepeat to 1$(RESET)\n"; \
	else \
		printf "$(YELLOW)  $(WARN) KeyRepeat already set to 1$(RESET)\n"; \
	fi
	@current_hold=$$(defaults read -g ApplePressAndHoldEnabled 2>/dev/null || echo "1"); \
	if [ "$$current_hold" != "0" ]; then \
		defaults write -g ApplePressAndHoldEnabled -bool false; \
		printf "$(GREEN)  ✓ Disabled press and hold$(RESET)\n"; \
	else \
		printf "$(YELLOW)  $(WARN) Press and hold already disabled$(RESET)\n"; \
	fi
	@if [ ! -f ~/Library/LaunchAgents/com.user.CapslockEscape.plist ]; then \
		printf "$(CYAN)  $(INFO) Creating Caps Lock to Escape mapping...$(RESET)\n"; \
		mkdir -p ~/Library/LaunchAgents; \
		printf '<?xml version="1.0" encoding="UTF-8"?>\n<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">\n<plist version="1.0">\n<dict>\n    <key>Label</key>\n    <string>com.user.CapslockEscape</string>\n    <key>ProgramArguments</key>\n    <array>\n        <string>/usr/bin/hidutil</string>\n        <string>property</string>\n        <string>--set</string>\n        <string>{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000029}]}</string>\n    </array>\n    <key>RunAtLoad</key>\n    <true/>\n</dict>\n</plist>\n' > ~/Library/LaunchAgents/com.user.CapslockEscape.plist; \
		launchctl bootout gui/$$(id -u)/com.user.CapslockEscape 2>/dev/null || true; \
		launchctl bootstrap gui/$$(id -u) ~/Library/LaunchAgents/com.user.CapslockEscape.plist 2>/dev/null || true; \
		hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000029}]}' >/dev/null; \
		printf "$(GREEN)  ✓ Caps Lock remapped to Escape$(RESET)\n"; \
	else \
		printf "$(YELLOW)  $(WARN) Caps Lock to Escape mapping already configured$(RESET)\n"; \
	fi
	@printf "$(GREEN)$(CHECK) macOS defaults configured$(RESET)\n"

# Install Homebrew
homebrew:
	@printf "$(BLUE)$(ARROW) 🍺 Installing Homebrew...$(RESET)\n"
	@if ! command -v brew &> /dev/null; then \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
		printf "$(GREEN)$(CHECK) Homebrew installed successfully$(RESET)\n"; \
	else \
		printf "$(YELLOW)$(WARN) Homebrew already installed$(RESET)\n"; \
	fi

# Core CLI tools
tools: homebrew
	@printf "$(BLUE)$(ARROW) 🔧 Installing core CLI tools...$(RESET)\n"
	@tools_to_install=""; \
	for tool in bash bazelisk git go gopls ispell jq neovim rg tmux starship; do \
		if ! brew list --formula $$tool &>/dev/null; then \
			tools_to_install="$$tools_to_install $$tool"; \
		fi; \
	done; \
	if [ -n "$$tools_to_install" ]; then \
		brew install --quiet $$tools_to_install 2>/dev/null || true; \
		printf "$(GREEN)  ✓ Installed tools:$$tools_to_install$(RESET)\n"; \
	else \
		printf "$(YELLOW)  $(WARN) All CLI tools already installed$(RESET)\n"; \
	fi
	@if ! brew list --cask ghostty &>/dev/null; then \
		brew install --cask --quiet ghostty 2>/dev/null || true; \
		printf "$(GREEN)  ✓ Installed Ghostty$(RESET)\n"; \
	else \
		printf "$(YELLOW)  $(WARN) Ghostty already installed$(RESET)\n"; \
	fi
	@if ! grep -q "$$(brew --prefix)/bin/bash" /etc/shells; then \
		printf "$(CYAN)  $(INFO) Adding Homebrew bash to /etc/shells...$(RESET)\n"; \
		echo "$$(brew --prefix)/bin/bash" | sudo tee -a /etc/shells; \
		printf "$(GREEN)  ✓ Added Homebrew bash to /etc/shells$(RESET)\n"; \
	else \
		printf "$(YELLOW)  $(WARN) Homebrew bash already in /etc/shells$(RESET)\n"; \
	fi
	@if ! command -v bun &> /dev/null; then \
		printf "$(CYAN)  $(INFO) Installing bun...$(RESET)\n"; \
		curl -fsSL https://bun.sh/install | bash; \
		printf "$(GREEN)  ✓ Bun installed$(RESET)\n"; \
	else \
		printf "$(YELLOW)  $(WARN) Bun already installed$(RESET)\n"; \
	fi
	@printf "$(CYAN)  $(INFO) Installing Go development tools...$(RESET)\n"; \
	go_tools_installed=0; \
	if ! command -v goimports &> /dev/null; then \
		go install golang.org/x/tools/cmd/goimports@latest 2>/dev/null && \
		printf "$(GREEN)    ✓ goimports installed$(RESET)\n" && \
		go_tools_installed=$$((go_tools_installed + 1)); \
	fi; \
	if ! command -v golangci-lint &> /dev/null; then \
		go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest 2>/dev/null && \
		printf "$(GREEN)    ✓ golangci-lint installed$(RESET)\n" && \
		go_tools_installed=$$((go_tools_installed + 1)); \
	fi; \
	if ! command -v gomodifytags &> /dev/null; then \
		go install github.com/fatih/gomodifytags@latest 2>/dev/null && \
		printf "$(GREEN)    ✓ gomodifytags installed$(RESET)\n" && \
		go_tools_installed=$$((go_tools_installed + 1)); \
	fi; \
	if ! command -v impl &> /dev/null; then \
		go install github.com/josharian/impl@latest 2>/dev/null && \
		printf "$(GREEN)    ✓ impl installed$(RESET)\n" && \
		go_tools_installed=$$((go_tools_installed + 1)); \
	fi; \
	if ! command -v gotests &> /dev/null; then \
		go install github.com/cweill/gotests/gotests@latest 2>/dev/null && \
		printf "$(GREEN)    ✓ gotests installed$(RESET)\n" && \
		go_tools_installed=$$((go_tools_installed + 1)); \
	fi; \
	if ! command -v dlv &> /dev/null; then \
		go install github.com/go-delve/delve/cmd/dlv@latest 2>/dev/null && \
		printf "$(GREEN)    ✓ delve (dlv) debugger installed$(RESET)\n" && \
		go_tools_installed=$$((go_tools_installed + 1)); \
	fi; \
	if [ $$go_tools_installed -eq 0 ]; then \
		printf "$(YELLOW)  $(WARN) All Go tools already installed$(RESET)\n"; \
	else \
		printf "$(GREEN)  ✓ Installed $$go_tools_installed Go tool(s)$(RESET)\n"; \
	fi
	@printf "$(GREEN)$(CHECK) Core tools installed$(RESET)\n"

# Container and Kubernetes tools
containers: homebrew
	@printf "$(BLUE)$(ARROW) 🐳 Installing container/K8s tools...$(RESET)\n"
	@containers_to_install=""; \
	for tool in docker helm k9s kubectl kubectx; do \
		if ! brew list --formula $$tool &>/dev/null; then \
			containers_to_install="$$containers_to_install $$tool"; \
		fi; \
	done; \
	if [ -n "$$containers_to_install" ]; then \
		brew install --quiet $$containers_to_install 2>/dev/null || true; \
		printf "$(GREEN)  ✓ Installed container tools:$$containers_to_install$(RESET)\n"; \
	else \
		printf "$(YELLOW)  $(WARN) All container tools already installed$(RESET)\n"; \
	fi
	@printf "$(GREEN)$(CHECK) Container tools installed$(RESET)\n"

# Window management tools
wm: homebrew
	@printf "$(BLUE)$(ARROW) 🪟 Installing window management tools...$(RESET)\n"
	@brew tap koekeishiya/formulae 2>/dev/null || true
	@if ! brew list --formula yabai &>/dev/null; then \
		brew install --quiet koekeishiya/formulae/yabai 2>/dev/null || true; \
		printf "$(GREEN)  ✓ Installed yabai$(RESET)\n"; \
	else \
		printf "$(YELLOW)  $(WARN) yabai already installed$(RESET)\n"; \
	fi
	@if ! brew list --formula skhd &>/dev/null; then \
		brew install --quiet koekeishiya/formulae/skhd 2>/dev/null || true; \
		printf "$(GREEN)  ✓ Installed skhd$(RESET)\n"; \
	else \
		printf "$(YELLOW)  $(WARN) skhd already installed$(RESET)\n"; \
	fi
	@brew tap FelixKratz/formulae 2>/dev/null || true
	@if ! brew list --formula sketchybar &>/dev/null; then \
		brew install --quiet sketchybar 2>/dev/null || true; \
		printf "$(GREEN)  ✓ Installed sketchybar$(RESET)\n"; \
	else \
		printf "$(YELLOW)  $(WARN) sketchybar already installed$(RESET)\n"; \
	fi
	@printf "$(GREEN)$(CHECK) Window management tools installed$(RESET)\n"

# Emacs installation
emacs: homebrew
	@printf "$(BLUE)$(ARROW) ⚡ Installing Emacs Plus...$(RESET)\n"
	@brew tap d12frosted/emacs-plus 2>/dev/null || true
	@brew install --quiet emacs-plus@29 2>/dev/null || true
	@if [ -d "/opt/homebrew/opt/emacs-plus@29/Emacs.app" ] && [ ! -e "/Applications/Emacs.app" ]; then \
		printf "$(CYAN)  $(INFO) Creating Emacs.app alias in Applications...$(RESET)\n"; \
		osascript -e 'tell application "Finder" to make alias file to posix file "/opt/homebrew/opt/emacs-plus@29/Emacs.app" at posix file "/Applications" with properties {name:"Emacs.app"}'; \
		printf "$(GREEN)  ✓ Emacs.app added to Applications$(RESET)\n"; \
	else \
		printf "$(YELLOW)  $(WARN) Emacs.app already exists in Applications or Emacs not installed$(RESET)\n"; \
	fi
	@printf "$(GREEN)$(CHECK) Emacs Plus installed$(RESET)\n"

# Doom Emacs installation
doomemacs: emacs
	@printf "$(BLUE)$(ARROW) 😈 Installing Doom Emacs...$(RESET)\n"
	@if [ ! -d "$(HOME)/.config/emacs" ]; then \
		printf "$(CYAN)  $(INFO) Cloning Doom Emacs...$(RESET)\n"; \
		git clone --depth 1 https://github.com/doomemacs/doomemacs $(HOME)/.config/emacs; \
		printf "$(GREEN)  ✓ Doom Emacs cloned$(RESET)\n"; \
		printf "$(CYAN)  $(INFO) Running Doom install...$(RESET)\n"; \
		$(HOME)/.config/emacs/bin/doom install; \
		printf "$(GREEN)  ✓ Doom Emacs installed$(RESET)\n"; \
	else \
		printf "$(YELLOW)  $(WARN) Doom Emacs already installed at ~/.config/emacs$(RESET)\n"; \
	fi
	@printf "$(GREEN)$(CHECK) Doom Emacs setup complete$(RESET)\n"

# Fonts
fonts: homebrew
	@printf "$(BLUE)$(ARROW) 🔤 Installing fonts...$(RESET)\n"
	@fonts_to_install=""; \
	for font in font-sf-pro font-fira-code font-fira-mono font-fira-sans font-hack-nerd-font font-jetbrains-mono-nerd-font; do \
		if ! brew list --formula $$font &>/dev/null; then \
			fonts_to_install="$$fonts_to_install $$font"; \
		fi; \
	done; \
	if [ -n "$$fonts_to_install" ]; then \
		brew install --quiet $$fonts_to_install 2>/dev/null || true; \
		printf "$(GREEN)  ✓ Installed fonts:$$fonts_to_install$(RESET)\n"; \
	else \
		printf "$(YELLOW)  $(WARN) All fonts already installed$(RESET)\n"; \
	fi
	@if ! brew list --cask sf-symbols &>/dev/null; then \
		brew install --cask --quiet sf-symbols 2>/dev/null || true; \
		printf "$(GREEN)  ✓ Installed SF Symbols$(RESET)\n"; \
	else \
		printf "$(YELLOW)  $(WARN) SF Symbols already installed$(RESET)\n"; \
	fi
	@printf "$(GREEN)$(CHECK) Fonts installed$(RESET)\n"

# Start system services
services:
	@printf "$(BLUE)$(ARROW) 🚀 Starting system services...$(RESET)\n"
	@skhd --start-service && printf "$(GREEN)  ✓ skhd service started$(RESET)\n" || printf "$(YELLOW)  $(WARN) skhd service already running or not installed$(RESET)\n"
	@yabai --start-service && printf "$(GREEN)  ✓ yabai service started$(RESET)\n" || printf "$(YELLOW)  $(WARN) yabai service already running or not installed$(RESET)\n"
	@brew services start sketchybar && printf "$(GREEN)  ✓ sketchybar service started$(RESET)\n" || printf "$(YELLOW)  $(WARN) sketchybar service already running or not installed$(RESET)\n"
	@if [ ! -d "$(HOME)/.tmux/plugins/tpm" ]; then \
		printf "$(CYAN)  $(INFO) Installing tmux plugin manager...$(RESET)\n"; \
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; \
		printf "$(GREEN)  ✓ tmux plugin manager installed$(RESET)\n"; \
	else \
		printf "$(YELLOW)  $(WARN) tmux plugin manager already installed$(RESET)\n"; \
	fi

# Function to create symlinks for a module
define symlink_module
	@printf "$(CYAN)$(ARROW) 🔗 Linking $(1) module...$(RESET)\n"
	@if [ -d "$(DOTFILES_DIR)/$(1)" ]; then \
		find "$(DOTFILES_DIR)/$(1)" -type f | while IFS= read -r file; do \
			relpath="$${file#$(DOTFILES_DIR)/$(1)/}"; \
			target="$(HOME_DIR)/$$relpath"; \
			if [ -e "$$target" ] && [ ! -L "$$target" ]; then \
				printf "$(YELLOW)  $(WARN) Removing existing non-symlink: $(GRAY)$$relpath$(RESET)\n"; \
				rm -rf "$$target"; \
			fi; \
			mkdir -p "$$(dirname "$$target")"; \
			ln -sf "$$file" "$$target"; \
			printf "$(GREEN)  ✓ Linked file: $(GRAY)$$target --> $$file$(RESET)\n"; \
			printf "$(GREEN)  ✓ Linked file: $(GRAY)$$relpath$(RESET)\n"; \
		done; \
		printf "$(GREEN)$(CHECK) $(1) module linked successfully$(RESET)\n"; \
	else \
		printf "$(RED)❌ Module $(1) directory not found$(RESET)\n"; \
	fi
endef

# Function to create symlink for root config files
define symlink_root_config
	@printf "$(CYAN)$(ARROW) 🔗 Linking $(1) configuration...$(RESET)\n"
	@if [ -f "$(DOTFILES_DIR)/.$(1)rc" ]; then \
		ln -sf "$(DOTFILES_DIR)/.$(1)rc" "$(HOME_DIR)/.$(1)rc"; \
		printf "$(GREEN)  ✓ Linked: $(GRAY).$(1)rc$(RESET)\n"; \
		printf "$(GREEN)$(CHECK) $(1) configuration linked successfully$(RESET)\n"; \
	else \
		printf "$(RED)❌ Configuration file .$(1)rc not found$(RESET)\n"; \
	fi
endef

# Module targets
bash:
	$(call symlink_module,bash)

claude: tools
	$(call symlink_module,claude)

doom: emacs
	$(call symlink_module,doom)

git:
	$(call symlink_module,git)

ghostty:
	$(call symlink_module,ghostty)

kitty:
	$(call symlink_module,kitty)

nvim:
	$(call symlink_module,nvim)

sketchybar: wm
	$(call symlink_module,sketchybar)

starship:
	$(call symlink_module,starship)

tmux:
	$(call symlink_module,tmux)

ccstatusline:
	$(call symlink_module,ccstatusline)

# Root configuration files
yabai: wm
	$(call symlink_root_config,yabai)

skhd: wm
	$(call symlink_root_config,skhd)

# Clean broken symlinks
clean:
	@printf "$(BLUE)$(ARROW) 🧹 Cleaning broken symlinks in home directory...$(RESET)\n"
	@broken_links=$$(find $(HOME_DIR) -maxdepth 3 -type l ! -exec test -e {} \; -print | grep -E '\.(config|doom\.d|tmux|bash|git)' | wc -l); \
	if [ "$$broken_links" -gt 0 ]; then \
		find $(HOME_DIR) -maxdepth 3 -type l ! -exec test -e {} \; -print | \
		grep -E '\.(config|doom\.d|tmux|bash|git)' | \
		while read -r link; do \
			printf "$(RED)  ✗ Removing: $(GRAY)$$link$(RESET)\n"; \
			rm "$$link"; \
		done; \
		printf "$(GREEN)$(CHECK) Cleaned $$broken_links broken symlinks$(RESET)\n"; \
	else \
		printf "$(GREEN)$(CHECK) No broken symlinks found$(RESET)\n"; \
	fi
