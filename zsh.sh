# Make zsh the default shell

# Install oh-my-zsh
echo "Insalling oh-my-zsh..."
git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

# Add custom theme
echo "Adding custom theme..."
mkdir -p ~/.oh-my-zsh/custom/themes/
cp ./zsh/se7entyse7en.zsh-theme ~/.oh-my-zsh/custom/themes/

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

echo "Setting default terminal theme..."
# Open terminal theme
open ./zsh/se7entyse7en-theme.terminal
# Set the 'se7entyse7en-theme' as the default
defaults write com.apple.Terminal "Startup Window Settings" -string "se7entyse7en-theme"
defaults write com.apple.Terminal "Default Window Settings" -string "se7entyse7en-theme"
