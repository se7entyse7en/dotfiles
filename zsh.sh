# Make zsh the default shell

# Install oh-my-zsh
echo "Insalling oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

# Copy .zshrc file
echo "Copying .zshrc configuration file..."
cp ./zsh/.zshrc ~/.zshrc

# Setting brew's zsh as default shell
zsh=$(brew --prefix)/bin/zsh
if grep -q $zsh /etc/shells; then
    echo "Setting brew's zsh as default shell..."
    sudo sh -c "echo '$zsh' >> /etc/shells"
    chsh -s $zsh
fi
