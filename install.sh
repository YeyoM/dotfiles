#!/usr/bin/env bash
# ------------------------------------------------------------------
# dotfiles install.sh
# Reproduces the full environment on a fresh machine:
#   1. Installs packages via apt
#   2. Clones external plugins/themes NOT tracked in this repo
#   3. Stows every config folder in this repo into $HOME
# ------------------------------------------------------------------
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Using dotfiles dir: $DOTFILES_DIR"

# ------------------------------------------------------------------
# 1. Packages
# ------------------------------------------------------------------
echo "==> Installing packages..."

PACKAGES=(
    stow
    git
    curl
    tmux
    i3-wm
    neovim
    kitty
    rofi
    zsh
    picom
    polybar
    zsh-syntax-highlighting
    eza
    bat
)

sudo apt update
sudo apt install -y "${PACKAGES[@]}"

# ------------------------------------------------------------------
# 2. External plugins / themes / frameworks NOT tracked in this repo
#    (each of these has its own git history / installer and is
#    gitignored inside the relevant tool folder — see .gitignore)
# ------------------------------------------------------------------
echo "==> Installing external plugins and frameworks..."

# --- oh-my-zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# --- powerlevel10k theme ---
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# --- zsh-autosuggestions plugin ---
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# --- fzf (generates ~/.fzf.zsh itself via its install script) ---
if [ ! -d "$HOME/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all --no-bash --no-fish
fi

# --- nvm ---
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi

# --- TPM (tmux plugin manager) ---
if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
    mkdir -p "$HOME/.config/tmux/plugins"
    git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
fi

# --- rofi-bluetooth ---
if [ ! -d "$HOME/rofi-bluetooth" ]; then
    git clone https://github.com/ClydeDroid/rofi-bluetooth "$HOME/rofi-bluetooth"
    chmod +x "$HOME/rofi-bluetooth/rofi-bluetooth"
fi

# --- spicetify CLI ---
if ! command -v spicetify &> /dev/null; then
    curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
fi

# --- spicetify-themes collection (the actual theme files, not tracked in this repo) ---
if [ ! -d "$HOME/.config/spicetify/Themes" ]; then
    git clone https://github.com/spicetify/spicetify-themes "$HOME/.config/spicetify/Themes"
fi

# --- packer.nvim (plugin manager itself) ---
if [ ! -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
    git clone --depth 20 https://github.com/wbthomason/packer.nvim \
        "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
fi

# ------------------------------------------------------------------
# 3. Stow every config folder in this repo
# ------------------------------------------------------------------
echo "==> Stowing dotfiles..."

cd "$DOTFILES_DIR"

for dir in */; do
    name="${dir%/}"
    stow -v -t "$HOME" "$name"
done

# after stow runs and config-xpui.ini is in place:
spicetify backup apply
spicetify config current_theme text color_scheme TokyoNight
spicetify apply

# ------------------------------------------------------------------
# Manual steps that can't be scripted
# ------------------------------------------------------------------
cat <<'EOF'

==> Done. A few things need a manual step:

  - Open tmux and press: prefix + I   (installs plugins via TPM)
  - Run: p10k configure                (only if you want to regenerate ~/.p10k.zsh,
                                         otherwise the tracked one will just work)
  - Log out/in (or reboot) for i3/zsh as your default shell/WM to fully apply
  - Run 'chsh -s $(which zsh)' if zsh isn't already your default shell

EOF
