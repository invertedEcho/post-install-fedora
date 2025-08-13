#!/bin/sh
set -e

mkdir -p ~/.local/bin

sudo dnf install neovim kitty zsh python3-pip trash-cli

flatpak install flathub com.spotify.Client

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
	rm -r ~/.local/bin/lua-language-server
	mv lua-language-server ~/.local/bin/
	echo "export PATH=$PATH:/home/invertedecho/.local/bin/lua-language-server/bin" >> ~/.zshrc
else
	echo "lua-language-server already installed, skipping"
fi

if ! command -v cargo >/dev/null 2>&1
then
	echo "Installing cargo and rustc via rustup"
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
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
	wget https://github.com/kamadorueda/alejandra/releases/download/4.0.0/alejandra-aarch64-unknown-linux-musl
	mv alejandra-x86_64-unknown-linux-musl ~/.local/bin/alejandra
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
	sudo dnf install lazygit
else
	echo "lazygit already installed, skipping"
fi

pip install pyright

# TODO: only do if font not yet installed
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts && curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/NoLigatures/Regular/JetBrainsMonoNLNerdFontMono-Regular.ttf && cd -

# zsh
sudo dnf install zsh-syntax-highlighting zsh-autosuggestions zoxide
mkdir -p "$HOME/.zsh"
sudo npm install --global pure-prompt

# TODO: clone dotfiles repo and run ./install
