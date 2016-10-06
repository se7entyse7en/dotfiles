# Make zsh the default shell

# Install oh-my-zsh
echo "Insalling oh-my-zsh..."
git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

# Copy .zshrc file
echo "Copying .zshrc configuration file..."
cp ./zsh/.zshrc ~/.zshrc

# Forcing zcompdump rebuild
if [ -f ~/.zcompdump ]; then
    rm -f ~/.zcompdump
    compinit -i
fi

ZSH_DEFAULT_SHELL=$(echo $SHELL | grep '/usr/local/bin/zsh')
if [ -z "$ZSH_DEFAULT_SHELL" ]; then
    echo "Setting zsh as default shell..."
    which zsh | sudo tee -a /etc/shells
    chsh -s $(which zsh)
fi
