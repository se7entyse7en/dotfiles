set -e

ZSH=${ZSH:-~/.oh-my-zsh}
if [ -d "$ZSH" ]; then
    echo "oh-my-zsh already installed"
else
    # Install oh-my-zsh
    echo "Insalling oh-my-zsh..."
    KEEP_ZSHRC=yes CHSH=no RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Copy .zshrc file
echo "Copying .zshrc configuration file..."
cp ./zsh/.zshrc ~/.zshrc
chmod -R go-w '/usr/local/share/zsh'

# Setting brew's zsh as default shell
zsh=$(brew --prefix)/bin/zsh
if grep -q $zsh /etc/shells; then
    echo "Setting brew's zsh as default shell..."
    sudo sh -c "echo '$zsh' >> /etc/shells"
    chsh -s $zsh
fi
