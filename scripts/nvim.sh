#!/bin/bash

# Install neovim for linux and add it to PATH
get_latest_nvim(){
	echo "Downloading and installing nvim into nvim-local"
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
	tar -zxvf nvim-linux64.tar.gz
	mv nvim-linux64 "$HOME/nvim-local"
		
	echo 'export PATH=${HOME}/nvim-local/bin:${PATH}' >> "$HOME/.bashrc"
	
	echo "alias vim='nvim'" >> "$HOME/.bashrc"

	# Delete zipped install for neovim
	echo 'Deleting zipped install for nvim'
	rm nvim-linux64.tar.gz
}

get_latest_nvim
