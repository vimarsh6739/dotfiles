# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
mv install.sh "$HOME"
sh "$HOME/install.sh"

# Install neovim locally
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
tar -zxvf "$HOME/nvim-local" nvim-linux64.tar.gz

# Add neovim PATH to zshrc
echo 'export PATH=${HOME}/nvim-local:${PATH}' >> "$HOME/.zshrc"

# Set neovim config to my kickstarter with clangd


