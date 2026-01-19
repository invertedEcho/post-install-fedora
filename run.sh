#!/bin/bash
set -e

check_if_program_installed() {
	local command_name=$1
	if ! command -v $command_name >/dev/null 2>&1
	then
		echo "Installing $command_name..."
		return 1
	else
		echo "Skipping installation of $command_name as its already installed."
		return 0
	fi
}

install_lua_language_server() {
	wget https://github.com/LuaLS/lua-language-server/releases/download/3.15.0/lua-language-server-3.15.0-linux-x64.tar.gz mkdir -p lua-language-server
	cd lua-language-server
	tar xf ../lua-language-server-3.15.0-linux-x64.tar.gz
	cd ..
	rm lua-language-server-3.15.0-linux-x64.tar.gz
	mv lua-language-server ~/.local/bin/
	echo "export PATH=$PATH:/home/invertedecho/.local/bin/lua-language-server/bin" >> ~/.zshrc
	rm -r lua-language-server
}

install_cargo() {
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	source ~/.cargo/env
}

install_onlyoffice() {
	wget https://github.com/ONLYOFFICE/DesktopEditors/releases/latest/download/onlyoffice-desktopeditors.x86_64.rpm -O /tmp/onlyoffice.rpm
	sudo dnf install -y /tmp/onlyoffice.rpm
}

install_feishin() {
  cd ~/.local/bin/
  curl 'https://raw.githubusercontent.com/jeffvli/feishin/refs/heads/development/install-feishin-appimage' | sh -s -- "/home/invertedecho/.local/bin"
  cd -
}

mkdir -p ~/.local/bin
mkdir -p ~/dev
mkdir -p ~/.config/gtk-4.0

export PATH=$PATH:/home/$USER/.local/bin/

if grep -q home-pc /etc/hostname; then
	flatpak install info.cemu.Cemu
fi

if grep -q laptop /etc/hostname; then
	echo "laptop detected, installing brightnessctl"
	sudo dnf install -y brightnessctl
fi

sudo dnf copr enable -y dejan/lazygit
sudo dnf copr enable -y solopasha/hyprland
sudo dnf install -y neovim kitty zsh python3-pip trash-cli wine gimp audacity redshift lazygit waypaper gtk-murrine-engine hyprland gammastep swww tmux wget rofi waybar nautilus firefox hyprpolkitagent

# Base stuff
if [ $SHELL != "/usr/bin/zsh" ]; then
	chsh -s /usr/bin/zsh
else
	echo "shell already set to zsh, skipping..."
fi


echo "Enabling RPM fusion repoistory"
sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

sudo dnf install -y \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm


# FIXME: this is broken
# check_if_program_installed "lua-language-server" || install_lua_language_server

check_if_program_installed "cargo" || install_cargo

check_if_program_installed "stylua" || cargo install stylua

check_if_program_installed "black" || pip install black

check_if_program_installed "prettierd" || sudo npm install -g @fsouza/prettierd

check_if_program_installed "pyright" || pip install pyright

check_if_program_installed "desktopeditors" || install_onlyoffice

check_if_program_installed "rust-analyzer" || rustup component add rust-analyzer

if [ ! -e ~/.local/bin/Feishin-linux-x86_64.AppImage ]
then
  echo "Feishin not installed, installing..."
  install_feishin
fi

# font
mkdir -p ~/.local/share/fonts
if [ ! -f /home/invertedecho/.local/share/fonts/JetBrainsMonoNLNerdFontMono-Regular.ttf ]
then
	echo "Installing JetBrainsMonoNerdFont"
	cd ~/.local/share/fonts
	curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/NoLigatures/Regular/JetBrainsMonoNLNerdFontMono-Regular.ttf
	cd -
else
	echo "JetBrainsMonoNerdFont already installed, skipping"
fi

# zsh
sudo dnf install zsh-syntax-highlighting zsh-autosuggestions zoxide
mkdir -p "$HOME/.zsh"

if ! npm list -g | grep pure-prompt
then
	echo "Installing pure-prompt..."
	sudo npm install --global pure-prompt
else
	echo "pure-prompt already installed, skipping"
fi

# dotfiles
if [ ! -d "/home/invertedecho/dev/dotfiles" ]; then
	git clone https://github.com/invertedEcho/dotfiles.git ~/dev/dotfiles
fi

cd ~/dev/dotfiles
rm -rf ~/.config/kitty
rm -f ~/.zshrc
./install
cd -

if [ ! -d "/home/invertedecho/dev/Gruvbox-GTK-Theme" ]; then
	git clone https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme ~/dev/Gruvbox-GTK-Theme
fi

cd ~/dev/Gruvbox-GTK-Theme/themes
./install.sh
cp -r ~/.themes/Gruvbox-Dark/gtk-4.0/* ~/.config/gtk-4.0/
cd -

if [ ! -d "/home/invertedecho/dev/nvim-config" ]; then
	git clone https://github.com/invertedEcho/nvim-config.git ~/dev/nvim-config
fi

if [ ! -d "/home/invertedecho/.config/nvim" ]; then
	echo "nvim-config not existing, setting up"
	ln -s /home/invertedecho/dev/nvim-config /home/invertedecho/.config/nvim
fi

echo "Post-install sucessfully completed!"
echo "Please log-out and log in to apply all changes."
