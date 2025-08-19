#!/bin/sh
set -e

mkdir -p ~/.local/bin
mkdir -p ~/dev
mkdir -p ~/.config/gtk-4.0

export PATH=$PATH:/home/$USER/.local/bin/

sudo dnf install -y neovim kitty zsh python3-pip trash-cli gnome-tweaks wine gnome-extensions-app

flatpak install info.cemu.Cemu

echo "Enabling RPM fusion repoistory"
sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

sudo dnf install -y \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

if ! command -v spotify >/dev/null 2>&1
then
	echo "Installing lpf-spotify-client"
	sudo dnf install lpf-spotify-client

	echo "Installing spotify by running lpf update"
	lpf update
else
	echo "Spotify already installed, skipping..."
fi

if [ $SHELL != "/usr/bin/zsh" ]; then
	chsh -s /usr/bin/zsh
else
	echo "shell already set to zsh, skipping..."
fi

if ! command -v lua-language-server >/dev/null 2>&1
then
	echo "lua-language-server not installed, installing"
	wget https://github.com/LuaLS/lua-language-server/releases/download/3.15.0/lua-language-server-3.15.0-linux-x64.tar.gz
	mkdir -p lua-language-server
	cd lua-language-server
	tar xf ../lua-language-server-3.15.0-linux-x64.tar.gz
	cd ..
	rm lua-language-server-3.15.0-linux-x64.tar.gz
	mv lua-language-server ~/.local/bin/
	echo "export PATH=$PATH:/home/invertedecho/.local/bin/lua-language-server/bin" >> ~/.zshrc
	rm -r lua-language-server
else
	echo "lua-language-server already installed, skipping"
fi

if ! command -v cargo >/dev/null 2>&1
then
	echo "Installing cargo and rustc via rustup"
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	source ~/.cargo/env
else
	echo "Cargo and rust already installed, skipping..."
fi

if ! command -v stylua >/dev/null 2>&1
then
	echo "Installing stylua with cargo"
	cargo install stylua
else
	echo "stylua already installed, skipping"
fi

if ! command -v black >/dev/null 2>&1
then
	echo "Installing black with pip"
	pip install black
else
	echo "black already installed, skipping"
fi

if ! command -v alejandra >/dev/null 2>&1
then
	echo "Installing alejandra"
	wget https://github.com/kamadorueda/alejandra/releases/download/4.0.0/alejandra-x86_64-unknown-linux-musl
	mv alejandra-x86_64-unknown-linux-musl ~/.local/bin/alejandra
	chmod +x ~/.local/bin/alejandra
else
	echo "alejandra already installed, skipping"
fi

if ! command -v prettierd >/dev/null 2>&1
then
	echo "Installing prettierd with npm"
	sudo npm install -g @fsouza/prettierd
else
	echo "prettierd already installed"
fi

if ! command -v lazygit >/dev/null 2>&1
then
	echo "Installing lazygit"
	sudo dnf copr enable dejan/lazygit
	sudo dnf install -y lazygit
else
	echo "lazygit already installed, skipping"
fi

if ! command -v pyright >/dev/null 2>&1
then
	echo "Installing pyright"
	pip install pyright
else
	echo "pyright already installed, skipping"
fi

rustup component add rust-analyzer

if ! command -v 1password >/dev/null 2>&1
then
	echo "Installing 1password"
	 sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
	 sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
	sudo dnf install 1password
else
	echo "1password already installed, skipping"
fi

# font
mkdir -p ~/.local/share/fonts
if [ ! -f /home/invertedecho/.local/share/fonts/JetBrainsMonoNLNerdFontMono-Regular.ttf ]; then
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
sudo npm install --global pure-prompt

# dotfiles
if [ ! -d "/home/invertedecho/dev/dotfiles" ]; then
	git clone https://github.com/invertedEcho/dotfiles.git ~/dev/dotfiles
fi

cd ~/dev/dotfiles
rm -rf ~/.config/kitty
rm -f ~/.zshrc
./install
cd -

# gtk
sudo dnf install gtk-murrine-engine

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

echo "Enabling minimize, maximize and close buttons for window tiltebars"
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
echo "Enabling resize-with-right-button for gnome"
gsettings set org.gnome.desktop.wm.preferences resize-with-right-button true

echo "Post-install sucessfully completed!"
echo "Please log-out and log in to apply all changes."
