#!/bin/bash

REPO_ROOT=$(pwd)

# Build and install nodejs locally
# Credits: https://askubuntu.com/questions/981799/how-to-install-node-js-without-sudo-access-but-with-npm-1-3-10-installed
install_nodejs(){
	INSTALL_DIR=${HOME}/.local
	SRC_DIR=${HOME}/node-latest-install

	mkdir -p ${INSTALL_DIR}
	mkdir -p ${SRC_DIR}
	cd ${SRC_DIR}

	# clone latest source and compile
	wget -c http://nodejs.org/dist/node-latest.tar.gz
	tar --strip-components=1 -zxvf node-latest.tar.gz
	./configure --prefix=${INSTALL_DIR}
	make -j $(nproc) 
	make install

	# add to PATH
	echo 'export PATH=${HOME}/.local/bin:${PATH}' >> "$HOME/.zshrc" 

	# optional: update npm to latest version
	wget -c https://www.npmjs.org/install.sh | sh
}

# Install nvim
install_nvim(){
	# Fetch and extract binaries
	curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz
	
	tar -zxvf nvim-linux-x86_64.tar.gz
	mv nvim-linux-x86_64 "$HOME/nvim-local"
	
	# Add to PATH
	echo 'export PATH=${HOME}/nvim-local/bin:${PATH}' >> "$HOME/.zshrc"
}

# Install conda
install_conda() {
	curl -LO https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
	mv "Miniconda3-latest-Linux-x86_64.sh" "$HOME" 
	sh "$HOME/Miniconda3-latest-Linux-x86_64.sh"
}

install_nodejs

# Configure extensions for oh-my-zsh
# autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# update the plugins line in zshrc
sed -i "s/plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/" "$HOME/.zshrc"

# Configure nvim
install_nvim
# alias vim to nvim
echo "alias vim='nvim'" >> "$HOME/.zshrc"
# set neovim config
mkdir -p "${HOME}/.config"
ln -s "${REPO_ROOT}/nvim.conf" "${HOME}/.config/nvim"
# set the git editor to nvim
git config --global core.editor "nvim"

# # Install miniconda
# install_conda 
# CHANGE THE CONDA SOLVER TO LIBMAMBA once it's installed. 
# Instructions are here: https://www.anaconda.com/blog/a-faster-conda-for-a-growing-community
# Note to self: Not automating this process now
# Assume CUDA and CUDNN is already installed in $HOME/local
# Add aliases to local path for the nvcc compiler
