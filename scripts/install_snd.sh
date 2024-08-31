#!/usr/bin/bash

# Configure extensions for oh-my-zsh
# autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# update the plugins line in zshrc
sed -i "s/plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/" "$HOME/.zshrc"

# Install neovim locally
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
tar -zxvf nvim-linux64.tar.gz

mv nvim-linux64 "$HOME/nvim-local" 

# Add neovim PATH to zshrc and config alias
echo 'export PATH=${HOME}/nvim-local/bin:${PATH}' >> "$HOME/.zshrc"
echo "alias vim='nvim'" >> "$HOME/.zshrc"

# Delete zipped install for neovim
echo 'Deleting zipped install for nvim'
rm nvim-linux64.tar.gz

# Set neovim config to my kickstarter with clangd
mkdir -p "$HOME/.config"
mv kickstart.nvim "$HOME/.config/nvim/"

# Download and install anaconda
curl -LO https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
mv "Miniconda3-latest-Linux-x86_64.sh" "$HOME" 
sh "$HOME/Miniconda3-latest-Linux-x86_64.sh"

# CHANGE THE CONDA SOLVER TO LIBMAMBA once it's installed. 
# Instructions are here: https://www.anaconda.com/blog/a-faster-conda-for-a-growing-community
# Note to self: Not automating this process now
# Assume CUDA and CUDNN is already installed in $HOME/local
# Add aliases to local path for the nvcc compiler
