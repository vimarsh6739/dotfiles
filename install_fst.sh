#!/usr/bin/bash

# Install oh-my-zsh
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
chmod +x install.sh
mv install.sh "$HOME"
source "$HOME/install.sh"


